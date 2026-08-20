import 'package:jaspr/jaspr.dart';

class LandingApp extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(id: 'landing-container', [
      _buildStyles(),
      _buildLiquidBackground(),
      _buildNavbar(),
      _buildHero(),
      _buildFeatures(),
      _buildPricing(),
      _buildSponsorSection(),
      _buildDownload(),
      _buildFooter(),
    ]);
  }

  Component _buildLiquidBackground() {
    return div(classes: 'liquid-bg', [
      div(classes: 'blob blob-1', []),
      div(classes: 'blob blob-2', []),
      div(classes: 'blob blob-3', []),
      div(classes: 'blob blob-4', []),
      div(classes: 'glass-overlay', []),
    ]);
  }

  Component _buildStyles() {
    return Style(styles: [
      StyleRule(selector: Selector('.liquid-bg'), styles: Styles.raw({
        'position': 'absolute',
        'top': '0',
        'left': '0',
        'width': '100%',
        'height': '100%',
      })),
      StyleRule(selector: Selector('.blob'), styles: Styles.raw({
        'position': 'absolute',
        'border-radius': '50%',
        'opacity': '0.45',
      })),
      StyleRule(selector: Selector('.blob-1'), styles: Styles.raw({
        'width': '600px',
        'height': '600px',
        'background': '#6366F1',
        'top': '-150px',
        'left': '-150px',
      })),
      StyleRule(selector: Selector('.blob-2'), styles: Styles.raw({
        'width': '500px',
        'height': '500px',
        'background': '#F43F5E',
        'bottom': '-100px',
        'right': '-100px',
      })),
      StyleRule(selector: Selector('.blob-3'), styles: Styles.raw({
        'width': '400px',
        'height': '400px',
        'background': '#A855F7',
        'top': '30%',
        'right': '20%',
      })),
      StyleRule(selector: Selector('.blob-4'), styles: Styles.raw({
        'width': '350px',
        'height': '350px',
        'background': '#3B82F6',
        'bottom': '20%',
        'left': '10%',
      })),
      StyleRule(selector: Selector('.glass-overlay'), styles: Styles.raw({
        'position': 'absolute',
        'top': '0',
        'left': '0',
        'width': '100%',
        'height': '100%',
      })),
      StyleRule(selector: Selector('.container'), styles: Styles.raw({
        'max-width': '1100px',
        'margin': '0 auto',
        'padding': '0 24px',
        'position': 'relative',
      })),
      StyleRule(selector: Selector('.navbar'), styles: Styles.raw({
        'padding': '25px',
      })),
      StyleRule(selector: Selector('.nav-content'), styles: Styles.raw({
        'display': 'flex',
        'justify-content': 'space-between',
        'align-items': 'center',
      })),
      StyleRule(selector: Selector('.logo'), styles: Styles.raw({
        'font-weight': '900',
        'font-size': '1.6rem',
        'color': 'white',
        'text-decoration': 'none',
        'display': 'flex',
        'align-items': 'center',
      })),
      StyleRule(selector: Selector('.btn-main'), styles: Styles.raw({
        'color': 'white',
        'padding': '16px 42px',
        'border-radius': '18px',
        'font-weight': '800',
        'font-size': '1.1rem',
        'cursor': 'pointer',
        'display': 'inline-block',
      })),
      StyleRule(selector: Selector('.hero'), styles: Styles.raw({
        'padding': '160px 0',
      })),
      StyleRule(selector: Selector('.hero h1'), styles: Styles.raw({
        'font-size': '4rem',
        'font-weight': '900',
        'margin-bottom': '24px',
        'line-height': '1',
      })),
      StyleRule(selector: Selector('.hero p'), styles: Styles.raw({
        'color': '#94A3B8',
        'font-size': '1.5rem',
        'max-width': '800px',
        'margin': '0',
        'margin-bottom': '56px',
        'line-height': '1.6',
      })),
      StyleRule(selector: Selector('.grid'), styles: Styles.raw({
        'display': 'grid',
        'gap': '32px',
        'padding': '80px 0',
      })),
      StyleRule(selector: Selector('.card'), styles: Styles.raw({
        'padding': '56px',
        'border-radius': '40px',
      })),
      StyleRule(selector: Selector('.card h3'), styles: Styles.raw({
        'font-size': '1.8rem',
        'margin-bottom': '12px',
        'font-weight': '800',
      })),
      StyleRule(selector: Selector('.p-card'), styles: Styles.raw({
        'padding': '72px',
        'border-radius': '48px',
        'text-align': 'center',
      })),
      StyleRule(selector: Selector('.p-card.featured'), styles: Styles.raw({
        'box-shadow': '0 0 80px #9966F126',
      })),
      StyleRule(selector: Selector('.price'), styles: Styles.raw({
        'font-size': '4.5rem',
        'font-weight': '900',
        'margin': '32px 0',
      })),
      StyleRule(selector: Selector('.sponsor-box'), styles: Styles.raw({
        'padding': '80px',
        'border-radius': '48px',
        'text-align': 'center',
        'margin': '80px 0',
      })),
      StyleRule(selector: Selector('.sponsor-box h2'), styles: Styles.raw({
        'font-weight': '800',
        'font-size': '2.5rem',
      })),
      StyleRule(selector: Selector('.sponsor-box p'), styles: Styles.raw({
        'max-width': '600px',
        'margin': '0',
        'margin-bottom': '32px',
        'color': '#94A3B8',
      })),
      StyleRule(selector: Selector('footer'), styles: Styles.raw({
        'padding': '100px',
        'text-align': 'center',
        'color': '#4B5563',
        'font-weight': '600',
      })),
      StyleRule(selector: Selector('.badge-btn'), styles: Styles.raw({
        'color': 'white',
        'padding': '20px',
        'border-radius': '20px',
        'text-decoration': 'none',
        'margin': '10px',
        'display': 'inline-flex',
        'align-items': 'center',
      })),
    ]);
  }

  Component _buildNavbar() {
    return nav(classes: 'navbar', [
      div(classes: 'container nav-content', [
        a(href: '/', classes: 'logo', [
          span([text('Markdown Studio')])
        ]),
        div([
          a(href: '/app', classes: 'btn-main', [text('Open Studio')])
        ]),
      ]),
    ]);
  }

  Component _buildHero() {
    return section(classes: 'hero container', [
      h1([text('Markdown Mastery.')]),
      p([text('Elevate your documentation with the most advanced visual editor. AI-powered precision, cloud-native stability.')]),
      a(href: '/app', classes: 'btn-main', [text('Start Creating Free')]),
    ]);
  }

  Component _buildFeatures() {
    return section(classes: 'container grid', [
      _featureCard('Visual Canvas', 'Design professional READMEs using a sleek component-based visual interface.'),
      _featureCard('Generative AI', 'Leverage Gemini AI to write descriptions, summaries, and complex technical docs.'),
      _featureCard('Pro Cloud', 'Secure cloud storage for all your projects with real-time sync across platforms.'),
    ]);
  }

  Component _buildPricing() {
    return section(id: 'pricing', classes: 'container', [
      h2([text('Simple Plans')]),
      p([text('Free for enthusiasts, powerful for professionals.')]),
      div(classes: 'grid', [
        _priceCard('Starter', '0', ['Standard Components', 'Standard Markdown Export', 'Community Support']),
        _priceCard('Pro Suite', '5', ['Unlimited AI Generation', 'Pro PDF/HTML Templates', 'Cloud Library Access', 'Ad-Free Experience'], isFeatured: true),
      ]),
    ]);
  }

  Component _buildSponsorSection() {
    return section(classes: 'container', [
      div(classes: 'sponsor-box', [
        h2([text('Support the Evolution')]),
        p([text('Help us build the future of technical documentation. Sponsors receive lifetime Pro status and exclusive badges.')]),
        a(href: 'https://buymeacoffee.com/yourname', classes: 'btn-main', [text('Become a Sponsor')]),
      ])
    ]);
  }

  Component _buildDownload() {
    return section(classes: 'container', [
      h3([text('Deploy Everywhere')]),
      div([
        _badgeBtn('Windows', '#'),
        _badgeBtn('Android', '#'),
      ])
    ]);
  }

  Component _badgeBtn(String label, String url) {
    return a(href: url, classes: 'badge-btn', [
      text(label)
    ]);
  }

  Component _priceCard(String title, String price, List<String> perks, {bool isFeatured = false}) {
    return div(classes: 'p-card${isFeatured ? ' featured' : ''}', [
      h3([text(title)]),
      div(classes: 'price', [text('\$$price')]),
      ul([
        for (var p in perks) li([text(p)])
      ]),
      a(href: '/app', classes: 'btn-main', [text('Join $title')])
    ]);
  }

  Component _featureCard(String title, String desc) {
    return div(classes: 'card', [
      h3([text(title)]),
      p([text(desc)]),
    ]);
  }

  Component _buildFooter() {
    return footer([div(classes: 'container', [text('© 2024 Markdown Studio Pro • Excellence in Documentation')])]);
  }
}
