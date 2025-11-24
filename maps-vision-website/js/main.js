// MAPS VISION - Main JavaScript

// DOM Elements
const navbar = document.querySelector('.navbar');
const navLinks = document.getElementById('navLinks');
const mobileMenuToggle = document.getElementById('mobileMenuToggle');

// Navbar scroll effect
function handleNavbarScroll() {
  if (window.scrollY > 50) {
    navbar.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
  }
}

// Mobile menu toggle
function toggleMobileMenu() {
  navLinks.classList.toggle('active');
  const icon = mobileMenuToggle.querySelector('i');

  if (navLinks.classList.contains('active')) {
    icon.classList.remove('fa-bars');
    icon.classList.add('fa-times');
  } else {
    icon.classList.remove('fa-times');
    icon.classList.add('fa-bars');
  }
}

// Close mobile menu when clicking a link
function closeMobileMenu() {
  navLinks.classList.remove('active');
  const icon = mobileMenuToggle.querySelector('i');
  icon.classList.remove('fa-times');
  icon.classList.add('fa-bars');
}

// Intersection Observer for scroll animations
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('animate-fadeInUp');
      observer.unobserve(entry.target);
    }
  });
}, observerOptions);

// Observe elements for animation
function initScrollAnimations() {
  const animateElements = document.querySelectorAll('.card, .value-card, .process-step, .faq-item, .offering-item');
  animateElements.forEach(el => {
    observer.observe(el);
  });
}

// Smooth scroll for anchor links
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      if (href === '#') return;

      e.preventDefault();
      const target = document.querySelector(href);

      if (target) {
        const offsetTop = target.offsetTop - 80;
        window.scrollTo({
          top: offsetTop,
          behavior: 'smooth'
        });
        closeMobileMenu();
      }
    });
  });
}

// Form submission handler
function initContactForm() {
  const contactForm = document.getElementById('contactForm');

  if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
      e.preventDefault();

      // Get form data
      const formData = new FormData(contactForm);
      const data = Object.fromEntries(formData);

      // Show success message (in a real app, you'd send this to a server)
      alert('Thank you for your message! We\'ll get back to you soon.');

      // Reset form
      contactForm.reset();

      // In production, you would send the data to your server:
      // fetch('/api/contact', {
      //   method: 'POST',
      //   headers: { 'Content-Type': 'application/json' },
      //   body: JSON.stringify(data)
      // })
      // .then(response => response.json())
      // .then(data => {
      //   // Handle success
      // })
      // .catch(error => {
      //   // Handle error
      // });
    });
  }
}

// Newsletter form handler
function initNewsletterForm() {
  const notifyForm = document.querySelector('.notify-form');

  if (notifyForm) {
    notifyForm.addEventListener('submit', function(e) {
      e.preventDefault();

      const email = this.querySelector('input[type="email"]').value;

      // Show success message
      alert(`Thanks! We'll notify you at ${email} when our portfolio launches.`);

      // Reset form
      this.reset();
    });
  }
}

// Parallax effect for hero elements
function initParallax() {
  window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const parallaxElements = document.querySelectorAll('.hero-visual, .visionary-character');

    parallaxElements.forEach(el => {
      if (el) {
        const speed = 0.5;
        el.style.transform = `translateY(${scrolled * speed}px)`;
      }
    });
  });
}

// Add active class to current page navigation link
function setActiveNavLink() {
  const currentPage = window.location.pathname.split('/').pop() || 'index.html';
  const navLinksArray = document.querySelectorAll('.nav-links a');

  navLinksArray.forEach(link => {
    const linkPage = link.getAttribute('href');
    if (linkPage === currentPage) {
      link.classList.add('active');
    } else {
      link.classList.remove('active');
    }
  });
}

// Initialize all functions when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  // Event listeners
  window.addEventListener('scroll', handleNavbarScroll);

  if (mobileMenuToggle) {
    mobileMenuToggle.addEventListener('click', toggleMobileMenu);
  }

  // Close mobile menu when clicking outside
  document.addEventListener('click', (e) => {
    if (!e.target.closest('.nav-container') && navLinks.classList.contains('active')) {
      closeMobileMenu();
    }
  });

  // Initialize features
  initScrollAnimations();
  initSmoothScroll();
  initContactForm();
  initNewsletterForm();
  initParallax();
  setActiveNavLink();

  // Initial navbar state
  handleNavbarScroll();
});

// Handle window resize
let resizeTimer;
window.addEventListener('resize', () => {
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(() => {
    // Close mobile menu on resize to desktop
    if (window.innerWidth > 768 && navLinks.classList.contains('active')) {
      closeMobileMenu();
    }
  }, 250);
});

// Preload images for better performance
function preloadImages() {
  const images = document.querySelectorAll('img[data-src]');

  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.removeAttribute('data-src');
        imageObserver.unobserve(img);
      }
    });
  });

  images.forEach(img => imageObserver.observe(img));
}

// Call preload on load
window.addEventListener('load', preloadImages);

// Add loading state management
window.addEventListener('load', () => {
  document.body.classList.add('loaded');
});

// Error handling for images
document.addEventListener('error', (e) => {
  if (e.target.tagName === 'IMG') {
    e.target.style.display = 'none';
    console.warn('Image failed to load:', e.target.src);
  }
}, true);

// Console message
console.log('%cMAPS VISION', 'font-size: 20px; font-weight: bold; color: #a855f7;');
console.log('%cWhere Vision Meets Intelligence', 'font-size: 14px; color: #cbd5e1;');
