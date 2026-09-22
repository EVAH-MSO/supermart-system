#!/bin/bash
# fix-pages.sh — recreate /order and /orders with full HTML/TS/CSS

set -e
APP=/d/4th/datawarehsing/project2/supermarket-system/frontend/src/app
cd "$APP"

mkdir -p pages/order pages/orders

# =========================================================
# ORDER PAGE (form to place an order)
# =========================================================
cat > pages/order/order.component.ts << 'XEOF'
import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Product } from '../../models/product.model';
import { Store } from '../../models/store.model';

@Component({
  selector: 'app-order',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './order.component.html',
  styleUrl: './order.component.css',
})
export class OrderComponent implements OnInit {
  products = signal<Product[]>([]);
  stores = signal<Store[]>([]);
  productId = 0;
  quantity = 1;
  storeId = 0;
  total = 0;
  loading = signal(true);
  submitting = signal(false);
  success = signal(false);
  errorMsg = signal('');

  constructor(private api: ApiService, private router: Router) {}

  ngOnInit() {
    this.api.getProducts().subscribe(d => { this.products.set(d); this.loading.set(false); });
    this.api.getStores().subscribe(d => { this.stores.set(d); if (d.length) this.storeId = d[0].id; });
  }

  recalc() {
    const p = this.products().find(x => x.id === +this.productId);
    this.total = p ? p.price * this.quantity : 0;
  }

  submit() {
    if (!localStorage.getItem('token')) {
      this.router.navigateByUrl('/login');
      return;
    }
    if (!this.productId || this.quantity < 1 || !this.storeId) return;

    this.submitting.set(true);
    this.errorMsg.set('');
    this.success.set(false);

    this.api.createOrder({
      product_id: this.productId,
      quantity: this.quantity,
      total: this.total,
      store_id: this.storeId,
    }).subscribe({
      next: () => {
        this.submitting.set(false);
        this.success.set(true);
        this.productId = 0;
        this.quantity = 1;
        this.total = 0;
        setTimeout(() => this.router.navigateByUrl('/orders'), 900);
      },
      error: (err: any) => {
        this.submitting.set(false);
        this.errorMsg.set(
          err.status === 401
            ? 'Please log in to place an order.'
            : 'Failed to place order.'
        );
      },
    });
  }
}
XEOF

cat > pages/order/order.component.html << 'XEOF'
<section class="page">
  <div class="page-header">
    <h1>Place an Order</h1>
    <p>Pick a product, choose your store, and confirm.</p>
  </div>

  <div class="order-layout">
    <div class="card form-card">
      <div *ngIf="loading()" class="state">Loading products...</div>

      <form *ngIf="!loading()" (ngSubmit)="submit()">
        <label>Product</label>
        <select [(ngModel)]="productId" name="product" (change)="recalc()">
          <option [ngValue]="0">— Select a product —</option>
          <option *ngFor="let p of products()" [ngValue]="p.id">
            {{ p.name }} — KSh {{ p.price }}
          </option>
        </select>

        <label>Quantity</label>
        <input type="number" [(ngModel)]="quantity" name="qty" min="1" (change)="recalc()" />

        <label>Store</label>
        <select [(ngModel)]="storeId" name="store">
          <option *ngFor="let s of stores()" [ngValue]="s.id">{{ s.name }} ({{ s.city }})</option>
        </select>

        <button type="submit" class="btn btn-primary submit"
                [disabled]="!productId || quantity < 1 || submitting()">
          {{ submitting() ? 'Placing...' : 'Place Order' }}
        </button>

        <div class="msg success" *ngIf="success()">
          ✅ Order placed! Redirecting to your orders...
        </div>
        <div class="msg error" *ngIf="errorMsg()">⚠️ {{ errorMsg() }}</div>
      </form>
    </div>

    <aside class="card summary">
      <h3>Order Summary</h3>
      <div class="summary-row">
        <span>Product</span>
        <strong>{{ productId ? (products().find(p => p.id === +productId)?.name || '—') : '—' }}</strong>
      </div>
      <div class="summary-row">
        <span>Quantity</span>
        <strong>{{ quantity }}</strong>
      </div>
      <div class="summary-row">
        <span>Unit price</span>
        <strong>KSh {{ products().find(p => p.id === +productId)?.price || 0 }}</strong>
      </div>
      <hr />
      <div class="summary-total">
        <span>Total</span>
        <strong>KSh {{ total }}</strong>
      </div>
      <p class="note">💡 Every order flows into the warehouse dashboard within 24 hours.</p>
    </aside>
  </div>
</section>
XEOF

cat > pages/order/order.component.css << 'XEOF'
.page { max-width: 1200px; margin: 0 auto; padding: 40px 24px; }
.page-header { margin-bottom: 32px; }
.page-header h1 { font-size: 2rem; font-weight: 800; color: #111827; margin-bottom: 6px; }
.page-header p { color: #6b7280; }

.order-layout { display: grid; grid-template-columns: 1.4fr 1fr; gap: 24px; align-items: start; }
.card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,.05); }

.form-card label { display: block; font-weight: 600; font-size: 14px; margin: 16px 0 6px; color: #374151; }
.form-card label:first-child { margin-top: 0; }
.form-card input, .form-card select {
  width: 100%; padding: 12px 14px; border: 1.5px solid #e5e7eb;
  border-radius: 8px; font-size: 15px; font-family: inherit;
}
.form-card input:focus, .form-card select:focus {
  outline: none; border-color: #00A86B; box-shadow: 0 0 0 3px rgba(0,168,107,.1);
}
.submit {
  width: 100%; justify-content: center; margin-top: 24px;
  padding: 12px; border: none; border-radius: 8px;
  background: linear-gradient(135deg, #00A86B, #007A4D);
  color: white; font-weight: 600; font-size: 15px; cursor: pointer;
}
.submit:disabled { opacity: .5; cursor: not-allowed; }
.msg { margin-top: 16px; padding: 12px 16px; border-radius: 8px; font-size: 14px; }
.msg.success { background: #dcfce7; color: #046A38; }
.msg.error { background: #fee2e2; color: #991b1b; }

.summary h3 { font-size: 1.05rem; margin-bottom: 18px; color: #111827; }
.summary-row { display: flex; justify-content: space-between; padding: 10px 0; font-size: 14px; color: #374151; }
.summary-row span { color: #6b7280; }
.summary hr { border: none; border-top: 1px solid #e5e7eb; margin: 12px 0; }
.summary-total { display: flex; justify-content: space-between; font-size: 1.1rem; font-weight: 700; color: #046A38; }
.note { margin-top: 20px; font-size: 12px; color: #6b7280; line-height: 1.5; }
.state { color: #6b7280; padding: 20px 0; }

@media (max-width: 900px) { .order-layout { grid-template-columns: 1fr; } }
XEOF

# =========================================================
# ORDERS PAGE (list of orders)
# =========================================================
cat > pages/orders/orders.component.ts << 'XEOF'
import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-orders',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './orders.component.html',
  styleUrl: './orders.component.css',
})
export class OrdersComponent implements OnInit {
  orders = signal<any[]>([]);
  loading = signal(true);
  error = signal('');

  constructor(private api: ApiService, public auth: AuthService, private router: Router) {}

  ngOnInit() {
    if (!this.auth.isLoggedIn) {
      this.router.navigateByUrl('/login');
      return;
    }
    this.api.getOrders().subscribe({
      next: (data) => { this.orders.set(data); this.loading.set(false); },
      error: (err: any) => {
        if (err.status === 401) this.auth.logout();
        else this.error.set('Could not load orders.');
        this.loading.set(false);
      },
    });
  }
}
XEOF

cat > pages/orders/orders.component.html << 'XEOF'
<section class="page">
  <div class="page-header">
    <h1>My Orders</h1>
    <p>Signed in as <strong>{{ auth.email() }}</strong></p>
  </div>

  <div class="card" *ngIf="loading()"><p>Loading your orders...</p></div>
  <div class="card err-card" *ngIf="error()"><p>⚠️ {{ error() }}</p></div>

  <div class="card empty" *ngIf="!loading() && !error() && orders().length === 0">
    <div class="empty-icon">📦</div>
    <h3>No orders yet</h3>
    <p>You haven't placed any orders. Start shopping!</p>
    <a routerLink="/order" class="btn-primary">Place your first order →</a>
  </div>

  <table class="orders-table" *ngIf="orders().length">
    <thead>
      <tr>
        <th>Order</th>
        <th>Product</th>
        <th>Qty</th>
        <th>Total</th>
        <th>Store</th>
        <th>Date</th>
      </tr>
    </thead>
    <tbody>
      <tr *ngFor="let o of orders()">
        <td><span class="order-id">#{{ o.id }}</span></td>
        <td><strong>{{ o.product_name }}</strong></td>
        <td>{{ o.quantity }}</td>
        <td class="total">KSh {{ o.total }}</td>
        <td>{{ o.store_name }}</td>
        <td><small>{{ o.created_at }}</small></td>
      </tr>
    </tbody>
  </table>
</section>
XEOF

cat > pages/orders/orders.component.css << 'XEOF'
.page { max-width: 1200px; margin: 0 auto; padding: 40px 24px; }
.page-header { margin-bottom: 24px; }
.page-header h1 { font-size: 2rem; font-weight: 800; color: #111827; margin-bottom: 6px; }
.page-header p { color: #6b7280; }
.card { background: white; border-radius: 14px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.err-card { color: #dc2626; }

.empty { text-align: center; padding: 60px 24px; color: #6b7280; }
.empty-icon { font-size: 4rem; margin-bottom: 12px; }
.empty h3 { color: #111827; margin-bottom: 8px; }
.empty .btn-primary {
  display: inline-block; margin-top: 16px; padding: 12px 24px;
  border-radius: 8px; background: linear-gradient(135deg, #00A86B, #007A4D);
  color: white; text-decoration: none; font-weight: 600;
}

.orders-table {
  width: 100%; border-collapse: collapse; background: white;
  border-radius: 14px; overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,.05);
}
.orders-table th {
  background: #f9fafb; text-align: left; padding: 14px 18px;
  font-size: 12px; text-transform: uppercase; letter-spacing: .04em;
  color: #6b7280; font-weight: 600;
}
.orders-table td {
  padding: 14px 18px; border-top: 1px solid #f3f4f6;
  font-size: 14px; color: #374151;
}
.orders-table tbody tr:hover { background: #f0fdf4; }
.total { font-weight: 700; color: #046A38; }
.order-id {
  background: #dcfce7; color: #046A38;
  padding: 3px 10px; border-radius: 12px;
  font-weight: 600; font-size: 12px;
}
XEOF

# =========================================================
# ROUTES — include everything
# =========================================================
cat > app.routes.ts << 'XEOF'
import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { ProductsComponent } from './pages/products/products.component';
import { OrderComponent } from './pages/order/order.component';
import { OrdersComponent } from './pages/orders/orders.component';
import { CustomersComponent } from './pages/customers/customers.component';
import { LoginComponent } from './pages/login/login.component';
import { SignupComponent } from './pages/signup/signup.component';
import { AboutComponent } from './pages/about/about.component';
import { PrivacyComponent } from './pages/privacy/privacy.component';
import { ContactComponent } from './pages/contact/contact.component';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'products', component: ProductsComponent },
  { path: 'order', component: OrderComponent },
  { path: 'orders', component: OrdersComponent },
  { path: 'customers', component: CustomersComponent },
  { path: 'login', component: LoginComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'about', component: AboutComponent },
  { path: 'privacy', component: PrivacyComponent },
  { path: 'contact', component: ContactComponent },
  { path: '**', redirectTo: '' },
];
XEOF

# =========================================================
# NAVBAR — clearly shows both Order and My Orders
# =========================================================
cat > app.component.html << 'XEOF'
<app-splash></app-splash>

<header class="navbar">
  <div class="nav-inner container">
    <a routerLink="/" class="brand">
      <span class="logo">🛒</span>
      <span class="brand-name">SuperMart</span>
    </a>

    <nav class="nav-links" [class.open]="menuOpen()">
      <a routerLink="/" routerLinkActive="active" [routerLinkActiveOptions]="{exact:true}">Home</a>
      <a routerLink="/products" routerLinkActive="active">Products</a>
      <a routerLink="/order" routerLinkActive="active">Order</a>
      <a routerLink="/orders" routerLinkActive="active" *ngIf="auth.isLoggedIn">My Orders</a>
      <a routerLink="/customers" routerLinkActive="active">Customers</a>
      <a routerLink="/about" routerLinkActive="active">About</a>

      <ng-container *ngIf="auth.isLoggedIn; else showLogin">
        <span class="user-chip">👤 {{ auth.email() }}</span>
        <button class="btn btn-ghost" (click)="logout()">Logout</button>
      </ng-container>
      <ng-template #showLogin>
        <a routerLink="/login" class="btn btn-primary nav-cta">Login</a>
      </ng-template>
    </nav>

    <button class="menu-toggle" (click)="toggleMenu()" aria-label="Menu">
      <span></span><span></span><span></span>
    </button>
  </div>
</header>

<main [class.page-anim]="pageKey()">
  <router-outlet></router-outlet>
</main>

<footer class="footer">
  <div class="container footer-inner">
    <div><strong>SuperMart</strong> — Retail Data Warehouse Demo</div>
    <div class="footer-links">
      <a routerLink="/about">About</a>
      <a routerLink="/privacy">Privacy</a>
      <a routerLink="/contact">Contact</a>
    </div>
  </div>
</footer>
XEOF

echo ""
echo "============================================"
echo "✅ Pages fixed"
echo "============================================"
echo ""
echo "Routes:"
echo "  /order   → place an order (form)"
echo "  /orders  → my orders (list, needs login)"
echo ""
echo "Restart Angular:  pnpm start"
