import { Component } from '@angular/core';

@Component({
  selector: 'app-about',
  standalone: true,
  template: `
    <section class="page">
      <div class="page-header">
        <h1>About SuperMart</h1>
        <p>Built as a full-stack data warehouse demo.</p>
      </div>
      <div class="content-card">
        <h2>What this project is</h2>
        <p>
          SuperMart is a full-stack retail system: an Angular frontend, a C++ backend,
          a MySQL database, a Python ETL pipeline, and a Streamlit analytics dashboard.
        </p>

        <h2>How it works</h2>
        <ol>
          <li>Customers place orders in the Angular app.</li>
          <li>The C++ API validates and writes them to MySQL.</li>
          <li>A nightly ETL job pulls new orders into a warehouse.</li>
          <li>The warehouse powers a live analytics dashboard.</li>
        </ol>

        <h2>Stack</h2>
        <div class="tags">
          <span>Angular</span>
          <span>C++ / Crow</span>
          <span>MySQL</span>
          <span>Python ETL</span>
          <span>Streamlit</span>
          <span>GitHub Actions</span>
        </div>
      </div>
    </section>
  `,
  styles: [`
    .page { max-width: 900px; margin: 0 auto; padding: 40px 24px; }
    .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; color: #111827; }
    .page-header p { color: #6b7280; margin-bottom: 24px; }
    .content-card {
      background: white; border-radius: 14px; padding: 32px;
      box-shadow: 0 2px 8px rgba(0,0,0,.05);
    }
    h2 { font-size: 1.15rem; margin: 20px 0 10px; color: #046A38; }
    h2:first-child { margin-top: 0; }
    p, li { color: #374151; line-height: 1.65; font-size: 15px; }
    ol { padding-left: 22px; }
    .tags { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px; }
    .tags span {
      background: #dcfce7; color: #046A38;
      padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 600;
    }
  `],
})
export class AboutComponent {}
