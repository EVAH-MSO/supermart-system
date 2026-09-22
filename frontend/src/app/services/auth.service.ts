import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { tap } from 'rxjs/operators';

const API = 'http://localhost:8080/api';

@Injectable({ providedIn: 'root' })
export class AuthService {
  email = signal<string | null>(localStorage.getItem('email'));
  token = signal<string | null>(localStorage.getItem('token'));

  constructor(private http: HttpClient, private router: Router) {}

  get isLoggedIn(): boolean {
    return !!this.token();
  }

  signup(email: string, password: string) {
    return this.http.post<any>(`${API}/auth/signup`, { email, password })
      .pipe(tap(res => this.saveSession(res)));
  }

  login(email: string, password: string) {
    return this.http.post<any>(`${API}/auth/login`, { email, password })
      .pipe(tap(res => this.saveSession(res)));
  }

  logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('email');
    this.token.set(null);
    this.email.set(null);
    this.router.navigateByUrl('/');
  }

  private saveSession(res: { token: string; email: string }) {
    localStorage.setItem('token', res.token);
    localStorage.setItem('email', res.email);
    this.token.set(res.token);
    this.email.set(res.email);
  }
}
