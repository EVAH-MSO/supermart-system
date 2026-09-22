import { Component, OnInit, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../services/api.service';
import { Product } from '../../models/product.model';

@Component({
  selector: 'app-products',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './products.component.html',
  styleUrl: './products.component.css',
})
export class ProductsComponent implements OnInit {
  products = signal<Product[]>([]);
  loading = signal(true);
  error = signal('');
  search = signal('');
  category = signal('all');

  categories = computed(() => {
    const set = new Set(this.products().map((p) => p.category));
    return ['all', ...Array.from(set)];
  });

  filtered = computed(() => {
    const q = this.search().toLowerCase();
    const cat = this.category();
    return this.products().filter(
      (p) => (cat === 'all' || p.category === cat) && (!q || p.name.toLowerCase().includes(q)),
    );
  });

  constructor(private api: ApiService) {}
  onImgError(event: any, name: string) {
    event.target.src = `https://placehold.co/400x300/E8F5E9/046A38?text=${encodeURIComponent(name)}`;
  }

  ngOnInit() {
    this.api.getProducts().subscribe({
      next: (data) => {
        this.products.set(data);
        this.loading.set(false);
      },
      error: () => {
        this.error.set('Could not load products. Is the backend running?');
        this.loading.set(false);
      },
    });
  }
}
