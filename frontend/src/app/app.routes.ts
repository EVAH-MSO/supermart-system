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
