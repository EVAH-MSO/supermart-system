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
