import { Component, signal } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive, Router, NavigationEnd } from '@angular/router';
import { CommonModule } from '@angular/common';
import { SplashComponent } from './shared/splash/splash.component';
import { AuthService } from './services/auth.service';
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

  constructor(public auth: AuthService, private router: Router) {
    this.router.events
      .pipe(filter(e => e instanceof NavigationEnd))
      .subscribe(() => this.pageKey.update(v => v + 1));
  }

  toggleMenu() { this.menuOpen.update(v => !v); }
  logout() { this.auth.logout(); }
}
