#!/bin/bash
# polish-frontend.sh — Adds splash screen, animations, extra pages.

set -e
APP=/d/4th/datawarehsing/project2/supermarket-system/frontend/src/app
SRC=/d/4th/datawarehsing/project2/supermarket-system/frontend/src

cd "$APP"

# ---------- extra page folders ----------
mkdir -p pages/about pages/privacy pages/contact
mkdir -p shared/splash

# =========================================================
# SPLASH / WELCOME SCREEN
# =========================================================
cat > shared/splash/splash.component.ts << 'XEOF'
import { Component, signal, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-splash',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './splash.component.html',
  styleUrl: './splash.component.css',
})
export class SplashComponent implements OnInit {
  visible = signal(true);

  ngOnInit() {
    // Hide after 2.4s
    setTimeout(() => this.visible.set(false), 2400);
  }
}
XEOF

cat > shared/splash/splash.component.html << 'XEOF'
<div class="splash" [class.hide]="!visible()" *ngIf="visible()">
  <div class="splash-content">
    <div class="cart">
      <div class="cart-icon">🛒</div>
      <div class="items">
        <span class="item i1">🥬</span>
        <span class="item i2">🍎</span>
        <span class="item i3">🥛</span>
        <span class="item i4">🍞</span>
        <span class="item i5">🍊</span>
      </div>
    </div>
    <h1 class="welcome-text">Welcome to <span>SuperMart</span></h1>
    <p class="tagline">Fresh groceries · Smart analytics</p>
    <div class="loader"><div class="bar"></div></div>
  </div>
</div>
XEOF

cat > shared/splash/splash.component.css << 'XEOF'
.splash {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: linear-gradient(135deg, #046A38 0%, #00A86B 100%);
  display: grid;
  place-items: center;
  overflow: hidden;
  transition: opacity .6s ease, transform .6s ease;
}
.splash.hide {
  opacity: 0;
  transform: scale(1.05);
  pointer-events: none;
}

.splash-content {
  text-align: center;
  color: white;
  animation: fadeInUp .8s ease both;
}

.cart {
  position: relative;
  display: inline-block;
  margin-bottom: 24px;
}
.cart-icon {
  font-size: 6rem;
  animation: bounce 1.4s ease-in-out infinite;
}

.items {
  position: absolute;
  inset: 0;
  pointer-events: none;
}
.item {
  position: absolute;
  font-size: 1.8rem;
  opacity: 0;
  animation: popUp 1.6s ease forwards;
}
.i1 { left: -30px;  top: -10px;  animation-delay: .3s; }
.i2 { right: -30px; top: -10px;  animation-delay: .5s; }
.i3 { left: -40px;  top: 30px;   animation-delay: .7s; }
.i4 { right: -40px; top: 30px;   animation-delay: .9s; }
.i5 { left: 50%;    top: -40px;  transform: translateX(-50%); animation-delay: 1.1s; }

.welcome-text {
  font-size: 2.4rem;
  font-weight: 800;
  margin-bottom: 10px;
  letter-spacing: -.5px;
  animation: fadeInUp .8s .3s ease both;
}
.welcome-text span {
  color: #FFE066;
  text-shadow: 0 2px 12px rgba(255,224,102,.4);
}

.tagline {
  font-size: 1rem;
  opacity: .85;
  margin-bottom: 32px;
  animation: fadeInUp .8s .5s ease both;
}

.loader {
  width: 220px;
  height: 4px;
  margin: 0 auto;
  background: rgba(255,255,255,.25);
  border-radius: 4px;
  overflow: hidden;
  animation: fadeInUp .8s .7s ease both;
}
.bar {
  height: 100%;
  width: 0;
  background: #FFE066;
  animation: load 2.2s ease forwards;
  border-radius: 4px;
}

@keyframes load {
  from { width: 0; }
  to   { width: 100%; }
}
@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50%      { transform: translateY(-14px); }
}
@keyframes popUp {
  0%   { opacity: 0; transform: translateY(20px) scale(.5); }
  40%  { opacity: 1; transform: translateY(-10px) scale(1.1); }
  100% { opacity: 0; transform: translateY(-40px) scale(.9); }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}
XEOF

# =========================================================
# ABOUT / PRIVACY / CONTACT (placeholder pages that lead somewhere)
# =========================================================
cat > pages/about/about.component.ts << 'XEOF'
import { Component } from '@angular/core';

@Component({
  selector: 'app-about',
  standalone: true,
  template: `
    <section class="page">
      <div class="page-header">
        <h1>About SuperMart</h1>
        <p>Built as a full-stack data warehouse demo.</p>
      </div>
      <div class="content-card">
        <h2>What this project is</h2>
        <p>
          SuperMart is a full-stack retail system: an Angular frontend, a C++ backend,
          a MySQL database, a Python ETL pipeline, and a Streamlit analytics dashboard.
        </p>

        <h2>How it works</h2>
        <ol>
          <li>Customers place orders in the Angular app.</li>
          <li>The C++ API validates and writes them to MySQL.</li>
          <li>A nightly ETL job pulls new orders into a warehouse.</li>
          <li>The warehouse powers a live analytics dashboard.</li>
        </ol>

        <h2>Stack</h2>
        <div class="tags">
          <span>Angular</span>
          <span>C++ / Crow</span>
          <span>MySQL</span>
          <span>Python ETL</span>
          <span>Streamlit</span>
          <span>GitHub Actions</span>
        </div>
      </div>
    </section>
  `,
  styles: [`
    .page { max-width: 900px; margin: 0 auto; padding: 40px 24px; }
    .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; color: #111827; }
    .page-header p { color: #6b7280; margin-bottom: 24px; }
    .content-card {
      background: white; border-radius: 14px; padding: 32px;
      box-shadow: 0 2px 8px rgba(0,0,0,.05);
    }
    h2 { font-size: 1.15rem; margin: 20px 0 10px; color: #046A38; }
    h2:first-child { margin-top: 0; }
    p, li { color: #374151; line-height: 1.65; font-size: 15px; }
    ol { padding-left: 22px; }
    .tags { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px; }
    .tags span {
      background: #dcfce7; color: #046A38;
      padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 600;
    }
  `],
})
export class AboutComponent {}
XEOF

cat > pages/privacy/privacy.component.ts << 'XEOF'
import { Component } from '@angular/core';

@Component({
  selector: 'app-privacy',
  standalone: true,
  template: `
    <section class="page">
      <div class="page-header">
        <h1>Privacy Policy</h1>
        <p>How SuperMart handles your data.</p>
      </div>
      <div class="content-card">
        <h2>Data we collect</h2>
        <p>Name, city, and order history — only what's needed to run the demo.</p>

        <h2>How we use it</h2>
        <p>To power order processing and analytics. No data is sold or shared.</p>

        <h2>Where it's stored</h2>
        <p>In a MySQL database, with a separate warehouse for analytics.</p>

        <h2>Your rights</h2>
        <p>Request deletion anytime by contacting the team.</p>

        <p class="note">This is a demo project. Do not submit real personal data.</p>
      </div>
    </section>
  `,
  styles: [`
    .page { max-width: 800px; margin: 0 auto; padding: 40px 24px; }
    .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; color: #111827; }
    .page-header p { color: #6b7280; margin-bottom: 24px; }
    .content-card {
      background: white; border-radius: 14px; padding: 32px;
      box-shadow: 0 2px 8px rgba(0,0,0,.05);
    }
    h2 { font-size: 1.05rem; margin: 20px 0 8px; color: #046A38; }
    h2:first-child { margin-top: 0; }
    p { color: #374151; line-height: 1.65; font-size: 15px; }
    .note { margin-top: 24px; padding: 12px 16px; background: #fef3c7; border-radius: 8px; color: #92400e; font-size: 14px; }
  `],
})
export class PrivacyComponent {}
XEOF

cat > pages/contact/contact.component.ts << 'XEOF'
import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <section class="page">
      <div class="page-header">
        <h1>Contact Us</h1>
        <p>We'd love to hear from you.</p>
      </div>

      <div class="contact-grid">
        <div class="card">
          <h3>Send a message</h3>
          <label>Your name</label>
          <input [(ngModel)]="name" placeholder="Jane Doe">
          <label>Email</label>
          <input [(ngModel)]="email" type="email" placeholder="jane@example.com">
          <label>Message</label>
          <textarea [(ngModel)]="message" rows="4" placeholder="How can we help?"></textarea>
          <button class="btn-primary" (click)="send()" [disabled]="!name || !email || !message">
            Send Message
          </button>
          <p *ngIf="sent()" class="success">✅ Thanks! We'll get back to you.</p>
        </div>

        <div class="card info">
          <h3>Other ways to reach us</h3>
          <div class="info-row"><span>📍</span><div><strong>Head office</strong><br>Nairobi, Kenya</div></div>
          <div class="info-row"><span>📞</span><div><strong>Phone</strong><br>+254 700 000 000</div></div>
          <div class="info-row"><span>✉️</span><div><strong>Email</strong><br>hello@supermart.co.ke</div></div>
          <div class="info-row"><span>🕐</span><div><strong>Hours</strong><br>Mon–Sat · 8am – 9pm</div></div>
        </div>
      </div>
    </section>
  `,
  styles: [`
    .page { max-width: 1000px; margin: 0 auto; padding: 40px 24px; }
    .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; color: #111827; }
    .page-header p { color: #6b7280; margin-bottom: 24px; }
    .contact-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px; }
    .card {
      background: white; border-radius: 14px; padding: 28px;
      box-shadow: 0 2px 8px rgba(0,0,0,.05);
    }
    h3 { font-size: 1.05rem; margin-bottom: 16px; color: #111827; }
    label { display: block; font-weight: 600; font-size: 13px; color: #374151; margin: 12px 0 6px; }
    input, textarea {
      width: 100%; padding: 11px 14px; border: 1.5px solid #e5e7eb;
      border-radius: 8px; font-size: 14px; font-family: inherit;
    }
    input:focus, textarea:focus { outline: none; border-color: #00A86B; box-shadow: 0 0 0 3px rgba(0,168,107,.1); }
    .btn-primary {
      margin-top: 16px; padding: 12px 22px; border: none; border-radius: 8px;
      background: linear-gradient(135deg, #00A86B, #007A4D); color: white;
      font-weight: 600; cursor: pointer; font-size: 15px; width: 100%;
    }
    .btn-primary:disabled { opacity: .5; cursor: not-allowed; }
    .success { margin-top: 12px; color: #046A38; font-weight: 600; }
    .info-row { display: flex; gap: 14px; padding: 14px 0; border-bottom: 1px solid #f3f4f6; font-size: 14px; color: #374151; }
    .info-row:last-child { border-bottom: none; }
    .info-row span { font-size: 1.4rem; }
    @media (max-width: 800px) { .contact-grid { grid-template-columns: 1fr; } }
  `],
})
export class ContactComponent {
  name = '';
  email = '';
  message = '';
  sent = signal(false);
  send() { this.sent.set(true); this.name = ''; this.email = ''; this.message = ''; }
}
XEOF

# =========================================================
# UPDATE ROOT APP — add splash + page transition
# =========================================================
cat > app.component.ts << 'XEOF'
import { Component, signal } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive, Router, NavigationEnd } from '@angular/router';
import { CommonModule } from '@angular/common';
import { SplashComponent } from './shared/splash/splash.component';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, CommonModule, SplashComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  menuOpen = signal(false);
  pageKey = signal(0);

  constructor(private router: Router) {
    // Trigger page transition on every route change
    this.router.events
      .pipe(filter(e => e instanceof NavigationEnd))
      .subscribe(() => this.pageKey.update(v => v + 1));
  }

  toggleMenu() { this.menuOpen.update(v => !v); }
}
XEOF

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
      <a routerLink="/customers" routerLinkActive="active">Customers</a>
      <a routerLink="/about" routerLinkActive="active">About</a>
      <a routerLink="/login" class="btn btn-primary nav-cta">Login</a>
    </nav>
    <button class="menu-toggle" (click)="toggleMenu()" aria-label="Menu">
      <span></span><span></span><span></span>
    </button>
  </div>
</header>

<main [@.disabled]="false" [class.page-anim]="pageKey()">
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

cat > app.component.css << 'XEOF'
.navbar {
  position: sticky; top: 0; z-index: 100;
  background: rgba(255,255,255,.9);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid #e5e7eb;
}
.nav-inner {
  display: flex; align-items: center; justify-content: space-between;
  height: 68px; max-width: 1200px; margin: 0 auto; padding: 0 24px;
}
.brand {
  display: flex; align-items: center; gap: 10px;
  text-decoration: none; font-weight: 800; font-size: 1.25rem; color: #046A38;
}
.brand .logo {
  font-size: 1.6rem;
  display: inline-block;
  transition: transform .3s;
}
.brand:hover .logo { transform: rotate(-12deg) scale(1.15); }
.nav-links { display: flex; align-items: center; gap: 4px; }
.nav-links a {
  color: #374151; text-decoration: none; padding: 8px 14px;
  border-radius: 8px; font-weight: 500; font-size: 15px;
  transition: all .2s ease;
  position: relative;
}
.nav-links a:hover { background: #f0fdf4; color: #046A38; transform: translateY(-1px); }
.nav-links a.active { background: #dcfce7; color: #046A38; }
.nav-cta { color: white !important; }
.nav-cta:hover { background: linear-gradient(135deg,#00A86B,#007A4D) !important; transform: translateY(-1px); }
.menu-toggle {
  display: none; flex-direction: column; gap: 5px;
  background: none; border: none; cursor: pointer; padding: 8px;
}
.menu-toggle span { display: block; width: 22px; height: 2px; background: #374151; border-radius: 2px; transition: all .25s; }
.menu-toggle:hover span { background: #046A38; }

@media (max-width: 900px) {
  .menu-toggle { display: flex; }
  .nav-links {
    display: none; position: absolute; top: 68px; left: 0; right: 0;
    background: white; flex-direction: column; padding: 16px; gap: 4px;
    border-bottom: 1px solid #e5e7eb;
    box-shadow: 0 8px 24px rgba(0,0,0,.08);
  }
  .nav-links.open { display: flex; }
  .nav-links a { width: 100%; }
}

.footer {
  margin-top: 80px; padding: 32px 0;
  background: #111827; color: #9ca3af; font-size: 14px;
}
.footer-inner {
  max-width: 1200px; margin: 0 auto; padding: 0 24px;
  display: flex; justify-content: space-between; align-items: center;
  flex-wrap: wrap; gap: 12px;
}
.footer strong { color: white; }
.footer-links a { color: #9ca3af; text-decoration: none; margin-left: 18px; transition: color .15s; }
.footer-links a:hover { color: white; }

/* Page transition on route change */
main.page-anim {
  animation: pageFade .45s ease both;
}
@keyframes pageFade {
  from { opacity: 0; transform: translateY(10px); }
  to   { opacity: 1; transform: translateY(0); }
}
XEOF

# =========================================================
# UPDATE ROUTES
# =========================================================
cat > app.routes.ts << 'XEOF'
import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { ProductsComponent } from './pages/products/products.component';
import { OrderComponent } from './pages/order/order.component';
import { CustomersComponent } from './pages/customers/customers.component';
import { LoginComponent } from './pages/login/login.component';
import { AboutComponent } from './pages/about/about.component';
import { PrivacyComponent } from './pages/privacy/privacy.component';
import { ContactComponent } from './pages/contact/contact.component';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'products', component: ProductsComponent },
  { path: 'order', component: OrderComponent },
  { path: 'customers', component: CustomersComponent },
  { path: 'login', component: LoginComponent },
  { path: 'about', component: AboutComponent },
  { path: 'privacy', component: PrivacyComponent },
  { path: 'contact', component: ContactComponent },
  { path: '**', redirectTo: '' },
];
XEOF

# =========================================================
# UPGRADE HOME HERO — animated cartoon illustration
# =========================================================
cat > pages/home/home.component.html << 'XEOF'
<section class="hero">
  <div class="hero-inner">
    <div class="hero-text">
      <span class="badge">🟢 Retail Data Warehouse</span>
      <h1>Fresh groceries.<br><span>Smart analytics.</span></h1>
      <p>Browse products, place orders in seconds, and watch your data flow into a real-time analytics dashboard — powered by a full ETL pipeline.</p>
      <div class="hero-buttons">
        <a routerLink="/products" class="btn btn-primary">Browse Products →</a>
        <a routerLink="/order" class="btn btn-ghost">Place an Order</a>
      </div>
      <div class="hero-stats">
        <div><strong>50+</strong><span>Products</span></div>
        <div><strong>10</strong><span>Stores</span></div>
        <div><strong>24/7</strong><span>Analytics</span></div>
      </div>
    </div>

    <!-- Animated cartoon illustration -->
    <div class="hero-illustration">
      <div class="bg-blob b1"></div>
      <div class="bg-blob b2"></div>

      <div class="cart-scene">
        <div class="cart-body">
          <div class="cart-basket">
            <span class="grocery g1">🥬</span>
            <span class="grocery g2">🍎</span>
            <span class="grocery g3">🥛</span>
            <span class="grocery g4">🍞</span>
            <span class="grocery g5">🍊</span>
          </div>
          <div class="cart-handle"></div>
          <div class="wheel w1"></div>
          <div class="wheel w2"></div>
        </div>

        <div class="floating f1">💳</div>
        <div class="floating f2">📊</div>
        <div class="floating f3">✨</div>
        <div class="floating f4">🛒</div>
      </div>
    </div>
  </div>
</section>

<section class="features">
  <div class="feature-card">
    <div class="icon">🛍️</div>
    <h3>Wide Selection</h3>
    <p>Everything from staples to household items, all in one place.</p>
  </div>
  <div class="feature-card">
    <div class="icon">⚡</div>
    <h3>Fast Orders</h3>
    <p>Place an order in under 10 seconds with our streamlined form.</p>
  </div>
  <div class="feature-card">
    <div class="icon">📊</div>
    <h3>Live Analytics</h3>
    <p>Every order flows into a real-time warehouse dashboard.</p>
  </div>
</section>
XEOF

cat > pages/home/home.component.css << 'XEOF'
/* ---------- Hero ---------- */
.hero {
  padding: 60px 24px 80px;
  background: linear-gradient(180deg, #f0fdf4 0%, #ffffff 100%);
  overflow: hidden;
}
.hero-inner {
  max-width: 1200px; margin: 0 auto;
  display: grid; grid-template-columns: 1fr 1fr; gap: 60px; align-items: center;
}
.badge {
  display: inline-block; background: white; color: #046A38;
  padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 600;
  margin-bottom: 20px; box-shadow: 0 2px 6px rgba(0,0,0,.05);
  animation: fadeInUp .6s ease both;
}
.hero-text h1 {
  font-size: 3rem; line-height: 1.1; font-weight: 800; color: #111827;
  margin-bottom: 20px; letter-spacing: -1px;
  animation: fadeInUp .6s .1s ease both;
}
.hero-text h1 span {
  background: linear-gradient(135deg, #046A38, #00A86B);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.hero-text p {
  color: #6b7280; font-size: 1.1rem; line-height: 1.6;
  margin-bottom: 32px; max-width: 480px;
  animation: fadeInUp .6s .2s ease both;
}
.hero-buttons {
  display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 48px;
  animation: fadeInUp .6s .3s ease both;
}
.hero-stats { display: flex; gap: 40px; animation: fadeInUp .6s .4s ease both; }
.hero-stats div { display: flex; flex-direction: column; }
.hero-stats strong { font-size: 1.6rem; font-weight: 800; color: #046A38; }
.hero-stats span { color: #6b7280; font-size: 13px; margin-top: 2px; }

/* ---------- Animated cartoon illustration ---------- */
.hero-illustration {
  position: relative;
  height: 420px;
  display: grid;
  place-items: center;
}
.bg-blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(40px);
  opacity: .5;
  z-index: 0;
}
.b1 {
  width: 320px; height: 320px;
  background: radial-gradient(circle, #00A86B, transparent);
  top: 10%; left: 5%;
  animation: blobFloat 8s ease-in-out infinite;
}
.b2 {
  width: 260px; height: 260px;
  background: radial-gradient(circle, #FFD166, transparent);
  bottom: 5%; right: 5%;
  animation: blobFloat 10s ease-in-out infinite reverse;
}

.cart-scene {
  position: relative;
  z-index: 1;
  width: 260px;
  height: 260px;
  animation: cartBounce 3s ease-in-out infinite;
}

/* Cart body */
.cart-body { position: relative; width: 100%; height: 100%; }

.cart-basket {
  position: absolute;
  top: 40px; left: 10px;
  width: 220px; height: 130px;
  background: linear-gradient(180deg, #f3f4f6, #d1d5db);
  border: 4px solid #374151;
  border-radius: 10px 10px 20px 20px;
  box-shadow: inset 0 -10px 20px rgba(0,0,0,.08);
}

/* Groceries peeking out */
.grocery {
  position: absolute;
  font-size: 2rem;
  animation: bob 2s ease-in-out infinite;
}
.g1 { top: -22px; left: 12px;  animation-delay: 0s; }
.g2 { top: -26px; left: 55px;  animation-delay: .2s; }
.g3 { top: -24px; left: 100px; animation-delay: .4s; }
.g4 { top: -20px; left: 145px; animation-delay: .6s; }
.g5 { top: -22px; left: 178px; animation-delay: .8s; }

/* Handle */
.cart-handle {
  position: absolute;
  top: 20px; left: 60px;
  width: 120px; height: 40px;
  border: 4px solid #374151;
  border-bottom: none;
  border-radius: 60px 60px 0 0;
}

/* Wheels */
.wheel {
  position: absolute;
  bottom: 20px;
  width: 34px; height: 34px;
  background: #374151;
  border-radius: 50%;
  border: 5px solid #9ca3af;
  animation: spin 1.4s linear infinite;
}
.w1 { left: 40px; }
.w2 { right: 40px; }

/* Floating icons around cart */
.floating {
  position: absolute;
  font-size: 1.8rem;
  animation: floatUp 4s ease-in-out infinite;
  opacity: 0.9;
}
.f1 { top: 10px;  right: 20px;  animation-delay: 0s; }
.f2 { bottom: 20px; left: 10px; animation-delay: 1s; }
.f3 { top: 90px;  right: -30px; animation-delay: 2s; }
.f4 { bottom: 60px; right: -20px; animation-delay: .5s; }

@keyframes cartBounce {
  0%, 100% { transform: translateY(0); }
  50%      { transform: translateY(-10px); }
}
@keyframes bob {
  0%, 100% { transform: translateY(0) rotate(0); }
  50%      { transform: translateY(-4px) rotate(4deg); }
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
@keyframes floatUp {
  0%, 100% { transform: translateY(0) rotate(0); opacity: .7; }
  50%      { transform: translateY(-14px) rotate(8deg); opacity: 1; }
}
@keyframes blobFloat {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50%      { transform: translate(20px, -20px) scale(1.1); }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* ---------- Features ---------- */
.features {
  max-width: 1200px; margin: 0 auto;
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;
  padding: 40px 24px 60px;
}
.feature-card {
  background: white; border-radius: 16px; padding: 32px;
  box-shadow: 0 4px 12px rgba(0,0,0,.05);
  transition: transform .3s, box-shadow .3s;
  animation: fadeInUp .5s ease both;
}
.feature-card:nth-child(1) { animation-delay: .1s; }
.feature-card:nth-child(2) { animation-delay: .2s; }
.feature-card:nth-child(3) { animation-delay: .3s; }
.feature-card:hover { transform: translateY(-8px); box-shadow: 0 18px 36px rgba(0,0,0,.08); }
.feature-card .icon {
  font-size: 2.2rem; margin-bottom: 16px;
  display: inline-block;
  transition: transform .3s;
}
.feature-card:hover .icon { transform: scale(1.2) rotate(-6deg); }
.feature-card h3 { font-size: 1.15rem; margin-bottom: 8px; color: #111827; }
.feature-card p { color: #6b7280; font-size: 14px; line-height: 1.55; }

@media (max-width: 900px) {
  .hero-inner { grid-template-columns: 1fr; gap: 40px; }
  .hero-text h1 { font-size: 2.2rem; }
  .features { grid-template-columns: 1fr; }
  .hero-illustration { height: 340px; }
  .cart-scene { transform: scale(.85); }
}
XEOF

echo ""
echo "============================================"
echo "✅ Frontend polished!"
echo "============================================"
echo ""
echo "  · Splash welcome screen (2.4s)"
echo "  · Animated cartoon cart on homepage"
echo "  · Page transitions on route change"
echo "  · About / Privacy / Contact pages"
echo "  · Footer links now work"
echo ""
echo "Run:  cd ../frontend && pnpm start"
echo ""
