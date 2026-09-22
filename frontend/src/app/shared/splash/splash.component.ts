import { Component, signal, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-splash',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './splash.component.html',
  styleUrl: './splash.component.css',
})
export class SplashComponent implements OnInit {
  visible = signal(true);

  ngOnInit() {
    // Hide after 2.4s
    setTimeout(() => this.visible.set(false), 2400);
  }
}
