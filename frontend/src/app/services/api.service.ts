import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Product } from '../models/product.model';
import { Store } from '../models/store.model';
import { Customer } from '../models/customer.model';

const API = 'https://supermart-system.onrender.com/api';

@Injectable({ providedIn: 'root' })
export class ApiService {

  constructor(private http: HttpClient) {}

  private authHeaders(): HttpHeaders {
    const token = localStorage.getItem('token');
    return new HttpHeaders(
      token ? { Authorization: `Bearer ${token}` } : {}
    );
  }

  // Public
  getProducts(): Observable<Product[]> {
    return this.http.get<Product[]>(`${API}/products`);
  }
  getStores(): Observable<Store[]> {
    return this.http.get<Store[]>(`${API}/stores`);
  }
  getCustomers(): Observable<Customer[]> {
    return this.http.get<Customer[]>(`${API}/customers`);
  }
  createCustomer(c: Customer): Observable<any> {
    return this.http.post(`${API}/customers`, c);
  }
  health(): Observable<any> {
    return this.http.get(`${API}/health`);
  }

  // Protected — need token
  createOrder(o: any): Observable<any> {
    return this.http.post(`${API}/orders`, o, { headers: this.authHeaders() });
  }
  getOrders(): Observable<any[]> {
    return this.http.get<any[]>(`${API}/orders`, { headers: this.authHeaders() });
  }
}
