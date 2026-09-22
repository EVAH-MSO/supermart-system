import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent {
  email = '';
  password = '';
  submitting = signal(false);
  error = signal('');

  constructor(private auth: AuthService, private router: Router) {}

  submit() {
    this.error.set('');
    if (!this.email || !this.password) {
      this.error.set('Please enter email and password');
      return;
    }

    this.submitting.set(true);
    this.auth.login(this.email, this.password).subscribe({
      next: () => {
        this.submitting.set(false);
        this.router.navigateByUrl('/orders');
      },
      error: (err: any) => {
        this.submitting.set(false);
        this.error.set(err.error?.detail || 'Invalid email or password');
      },
    });
  }
}
