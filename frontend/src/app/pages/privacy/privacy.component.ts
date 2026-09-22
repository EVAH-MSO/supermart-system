import { Component } from '@angular/core';

@Component({
  selector: 'app-privacy',
  standalone: true,
  template: `
    <section class="page">
      <div class="page-header">
        <h1>Privacy Policy</h1>
        <p>How SuperMart handles your data.</p>
      </div>
      <div class="content-card">
        <h2>Data we collect</h2>
        <p>Name, city, and order history — only what's needed to run the demo.</p>

        <h2>How we use it</h2>
        <p>To power order processing and analytics. No data is sold or shared.</p>

        <h2>Where it's stored</h2>
        <p>In a MySQL database, with a separate warehouse for analytics.</p>

        <h2>Your rights</h2>
        <p>Request deletion anytime by contacting the team.</p>

        <p class="note">This is a demo project. Do not submit real personal data.</p>
      </div>
    </section>
  `,
  styles: [`
    .page { max-width: 800px; margin: 0 auto; padding: 40px 24px; }
    .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; color: #111827; }
    .page-header p { color: #6b7280; margin-bottom: 24px; }
    .content-card {
      background: white; border-radius: 14px; padding: 32px;
      box-shadow: 0 2px 8px rgba(0,0,0,.05);
    }
    h2 { font-size: 1.05rem; margin: 20px 0 8px; color: #046A38; }
    h2:first-child { margin-top: 0; }
    p { color: #374151; line-height: 1.65; font-size: 15px; }
    .note { margin-top: 24px; padding: 12px 16px; background: #fef3c7; border-radius: 8px; color: #92400e; font-size: 14px; }
  `],
})
export class PrivacyComponent {}
