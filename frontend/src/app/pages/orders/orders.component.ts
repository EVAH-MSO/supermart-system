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
