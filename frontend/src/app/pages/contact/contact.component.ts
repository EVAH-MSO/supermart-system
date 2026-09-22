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
