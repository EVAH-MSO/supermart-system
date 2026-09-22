import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../services/api.service';
import { Customer } from '../../models/customer.model';

@Component({
  selector: 'app-customers',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './customers.component.html',
  styleUrl: './customers.component.css',
})
export class CustomersComponent implements OnInit {
  customers = signal<Customer[]>([]);
  loading = signal(true);
  newName = '';
  newCity = '';
  submitting = signal(false);
  message = signal('');
  success = signal(false);

  constructor(private api: ApiService) {}

  ngOnInit() { this.load(); }

  load() {
    this.api.getCustomers().subscribe(d => { this.customers.set(d); this.loading.set(false); });
  }

  add() {
    if (!this.newName.trim() || !this.newCity.trim()) return;
    this.submitting.set(true);
    this.api.createCustomer({ name: this.newName, city: this.newCity }).subscribe({
      next: () => {
        this.submitting.set(false);
        this.success.set(true);
        this.message.set('Customer added');
        this.newName = '';
        this.newCity = '';
        this.load();
      },
      error: () => {
        this.submitting.set(false);
        this.success.set(false);
        this.message.set('Failed to add customer');
      },
    });
  }
}
