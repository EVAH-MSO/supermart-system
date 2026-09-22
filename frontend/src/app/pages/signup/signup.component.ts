import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './signup.component.html',
  styleUrl: './signup.component.css',
})
export class SignupComponent {
  email = '';
  password = '';
  confirm = '';
  submitting = signal(false);
  error = signal('');

  constructor(private auth: AuthService, private router: Router) {}

  submit() {
    this.error.set('');

    if (!this.email || !this.password) {
      this.error.set('Please fill in all fields');
      return;
    }
    if (this.password.length < 6) {
      this.error.set('Password must be at least 6 characters');
      return;
    }
    if (this.password !== this.confirm) {
      this.error.set('Passwords do not match');
      return;
    }

    this.submitting.set(true);
    this.auth.signup(this.email, this.password).subscribe({
      next: () => {
        this.submitting.set(false);
        this.router.navigateByUrl('/orders');
      },
      error: (err: any) => {
        this.submitting.set(false);
        this.error.set(err.error?.detail || 'Signup failed. Try a different email.');
      },
    });
  }
}
