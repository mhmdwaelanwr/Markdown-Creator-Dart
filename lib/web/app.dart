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
    return Style(rules: [
      css('.liquid-bg').styles(
        position: Position.absolute(),
        top: Unit.pixels(0),
        left: Unit.pixels(0),
        width: Unit.percent(100),
        height: Unit.percent(100),
      ),
      css('.blob').styles(
        position: Position.absolute(),
        borderRadius: BorderRadius.all(Radius.circular(Unit.percent(50))),
        opacity: 0.45,
      ),
      css('.blob-1').styles(
        width: Unit.pixels(600),
        height: Unit.pixels(600),
        background: Color('#6366F1'),
        top: Unit.pixels(-150),
        left: Unit.pixels(-150),
      ),
      css('.blob-2').styles(
        width: Unit.pixels(500),
        height: Unit.pixels(500),
        background: Color('#F43F5E'),
        bottom: Unit.pixels(-100),
        right: Unit.pixels(-100),
      ),
      css('.blob-3').styles(
        width: Unit.pixels(400),
        height: Unit.pixels(400),
        background: Color('#A855F7'),
        top: Unit.percent(30),
        right: Unit.percent(20),
      ),
      css('.blob-4').styles(
        width: Unit.pixels(350),
        height: Unit.pixels(350),
        background: Color('#3B82F6'),
        bottom: Unit.percent(20),
        left: Unit.percent(10),
      ),
      css('.glass-overlay').styles(
        position: Position.absolute(),
        top: Unit.pixels(0),
        left: Unit.pixels(0),
        width: Unit.percent(100),
        height: Unit.percent(100),
      ),
      css('.container').styles(
        maxWidth: Unit.pixels(1100),
        margin: Margin.symmetric(horizontal: Unit.auto),
        padding: Padding.symmetric(horizontal: Unit.pixels(24)),
        position: Position.relative(),
      ),
      css('.navbar').styles(
        padding: Padding.all(Unit.pixels(25)),
        position: Position.sticky(),
        top: Unit.pixels(0),
      ),
      css('.nav-content').styles(
        display: Display.flex(),
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
      ),
      css('.logo').styles(
        fontWeight: FontWeight.w900,
        fontSize: Unit.rem(1.6),
        color: Colors.white,
        textDecoration: TextDecoration.none(),
        display: Display.flex(),
        alignItems: AlignItems.center,
      ),
      css('.btn-main').styles(
        color: Colors.white,
        padding: Padding.symmetric(vertical: Unit.pixels(16), horizontal: Unit.pixels(42)),
        borderRadius: BorderRadius.all(Radius.circular(Unit.pixels(18))),
        fontWeight: FontWeight.w800,
        fontSize: Unit.rem(1.1),
        border: Border.all(Unit.pixels(0)),
        cursor: Cursor.pointer(),
        display: Display.inlineBlock(),
      ),
      css('.hero').styles(
        padding: Padding.symmetric(vertical: Unit.pixels(160)),
      ),
      css('.hero h1').styles(
        fontSize: Unit.rem(4),
        fontWeight: FontWeight.w900,
        marginBottom: Unit.pixels(24),
        lineHeight: Unit.rem(1),
      ),
      css('.hero p').styles(
        color: Color('#94A3B8'),
        fontSize: Unit.rem(1.5),
        maxWidth: Unit.pixels(800),
        margin: Margin.all(Unit.pixels(0)),
        marginBottom: Unit.pixels(56),
        lineHeight: Unit.rem(1.6),
      ),
      css('.grid').styles(
        display: Display.grid(),
        gap: Unit.pixels(32),
        padding: Unit.pixels(80),
      ),
      css('.card').styles(
        padding: Padding.all(Unit.pixels(56)),
        borderRadius: BorderRadius.all(Radius.circular(Unit.pixels(40))),
        border: Border.all(Unit.pixels(1), color: Color('#ffffff14')),
      ),
      css('.card h3').styles(
        fontSize: Unit.rem(1.8),
        marginBottom: Unit.pixels(12),
        fontWeight: FontWeight.w800,
      ),
      css('.p-card').styles(
        padding: Padding.all(Unit.pixels(72)),
        borderRadius: BorderRadius.all(Radius.circular(Unit.pixels(48))),
        textAlign: TextAlign.center,
      ),
      css('.p-card.featured').styles(
        boxShadow: BoxShadow([
          BoxShadowItem(offset: Unit.pixels(0), blur: Unit.pixels(80), color: Color('#9966F126')),
        ]),
      ),
      css('.price').styles(
        fontSize: Unit.rem(4.5),
        fontWeight: FontWeight.w900,
        margin: Margin.symmetric(vertical: Unit.pixels(32)),
      ),
      css('.sponsor-box').styles(
        padding: Padding.all(Unit.pixels(80)),
        borderRadius: BorderRadius.all(Radius.circular(Unit.pixels(48))),
        textAlign: TextAlign.center,
        margin: Margin.symmetric(vertical: Unit.pixels(80)),
        border: Border.all(Unit.pixels(1), color: Color('#f43f5e33')),
      ),
      css('.sponsor-box h2').styles(
        fontWeight: FontWeight.w800,
        fontSize: Unit.rem(2.5),
      ),
      css('.sponsor-box p').styles(
        maxWidth: Unit.pixels(600),
        margin: Margin.all(Unit.pixels(0)),
        marginBottom: Unit.pixels(32),
        color: Color('#94A3B8'),
      ),
      css('footer').styles(
        padding: Padding.all(Unit.pixels(100)),
        textAlign: TextAlign.center,
        color: Color('#4B5563'),
        fontWeight: FontWeight.w600,
      ),
      css('.badge-btn').styles(
        color: Colors.white,
        padding: Padding.all(Unit.pixels(20)),
        borderRadius: BorderRadius.all(Radius.circular(Unit.pixels(20))),
        textDecoration: TextDecoration.none(),
        margin: Margin.all(Unit.pixels(10)),
        border: Border.all(Unit.pixels(1), color: Color('#ffffff14')),
        display: Display.inlineFlex(),
        alignItems: AlignItems.center,
      ),
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
