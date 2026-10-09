import 'package:flutter/widgets.dart';
import 'package:simple_icons/simple_icons.dart';

/// Brand-name → official logo icon mappings.
/// Covers major global brands + popular Indian services.
class BrandDictionary {
  static const Map<String, IconData> brands = {
    // ── Streaming & Entertainment ─────────────────────────────
    'netflix': SimpleIcons.netflix,
    'spotify': SimpleIcons.spotify,
    'hbo': SimpleIcons.hbo,
    'applemusic': SimpleIcons.applemusic,
    'appletv': SimpleIcons.appletv,
    'youtube': SimpleIcons.youtube,
    'youtubemusic': SimpleIcons.youtubemusic,
    'twitch': SimpleIcons.twitch,
    'soundcloud': SimpleIcons.soundcloud,
    'deezer': SimpleIcons.deezer,
    'tidal': SimpleIcons.tidal,
    'crunchyroll': SimpleIcons.crunchyroll,
    'audible': SimpleIcons.audible,

    // ── Social Media ──────────────────────────────────────────
    'x': SimpleIcons.x,
    'meta': SimpleIcons.meta,
    'facebook': SimpleIcons.facebook,
    'instagram': SimpleIcons.instagram,
    'tiktok': SimpleIcons.tiktok,
    'snapchat': SimpleIcons.snapchat,
    'pinterest': SimpleIcons.pinterest,
    'reddit': SimpleIcons.reddit,
    'tumblr': SimpleIcons.tumblr,
    'whatsapp': SimpleIcons.whatsapp,
    'telegram': SimpleIcons.telegram,
    'signal': SimpleIcons.signal,
    'wechat': SimpleIcons.wechat,
    'line': SimpleIcons.line,
    'threads': SimpleIcons.threads,
    'mastodon': SimpleIcons.mastodon,
    'bluesky': SimpleIcons.bluesky,

    // ── Ride-hailing & Delivery ───────────────────────────────
    'uber': SimpleIcons.uber,
    'ubereats': SimpleIcons.ubereats,
    'lyft': SimpleIcons.lyft,
    'grab': SimpleIcons.grab,
    'doordash': SimpleIcons.doordash,
    'deliveroo': SimpleIcons.deliveroo,
    'instacart': SimpleIcons.instacart,
    // Indian
    'swiggy': SimpleIcons.swiggy,
    'zomato': SimpleIcons.zomato,
    'dunzo': SimpleIcons.dunzo,

    // ── Food & Beverage Chains ────────────────────────────────
    'mcdonalds': SimpleIcons.mcdonalds,
    'starbucks': SimpleIcons.starbucks,
    'burgerking': SimpleIcons.burgerking,
    'kfc': SimpleIcons.kfc,
    'tacobell': SimpleIcons.tacobell,

    // ── E-Commerce & Retail ───────────────────────────────────
    'ebay': SimpleIcons.ebay,
    'etsy': SimpleIcons.etsy,
    'shopify': SimpleIcons.shopify,
    'ikea': SimpleIcons.ikea,
    'target': SimpleIcons.target,
    'zara': SimpleIcons.zara,
    'uniqlo': SimpleIcons.uniqlo,
    'aliexpress': SimpleIcons.aliexpress,
    'wish': SimpleIcons.wish,

    // ── Sportswear & Fashion ──────────────────────────────────
    'nike': SimpleIcons.nike,
    'adidas': SimpleIcons.adidas,
    'puma': SimpleIcons.puma,
    'reebok': SimpleIcons.reebok,
    'newbalance': SimpleIcons.newbalance,
    'underarmour': SimpleIcons.underarmour,
    'northface': SimpleIcons.thenorthface,

    // ── Tech & Software ───────────────────────────────────────
    'apple': SimpleIcons.apple,
    'google': SimpleIcons.google,
    'samsung': SimpleIcons.samsung,
    'oneplus': SimpleIcons.oneplus,
    'xiaomi': SimpleIcons.xiaomi,
    'huawei': SimpleIcons.huawei,
    'lenovo': SimpleIcons.lenovo,
    'dell': SimpleIcons.dell,
    'hp': SimpleIcons.hp,
    'asus': SimpleIcons.asus,
    'acer': SimpleIcons.acer,
    'intel': SimpleIcons.intel,
    'nvidia': SimpleIcons.nvidia,
    'amd': SimpleIcons.amd,
    'sony': SimpleIcons.sony,

    // ── Design & Productivity ─────────────────────────────────
    'figma': SimpleIcons.figma,
    'sketch': SimpleIcons.sketch,
    'dribbble': SimpleIcons.dribbble,
    'behance': SimpleIcons.behance,
    'notion': SimpleIcons.notion,
    'trello': SimpleIcons.trello,
    'jira': SimpleIcons.jira,
    'asana': SimpleIcons.asana,
    'todoist': SimpleIcons.todoist,
    'linear': SimpleIcons.linear,
    'miro': SimpleIcons.miro,
    'airtable': SimpleIcons.airtable,
    'clickup': SimpleIcons.clickup,

    // ── Developer / Cloud ─────────────────────────────────────
    'github': SimpleIcons.github,
    'gitlab': SimpleIcons.gitlab,
    'bitbucket': SimpleIcons.bitbucket,
    'dropbox': SimpleIcons.dropbox,
    'googledrive': SimpleIcons.googledrive,
    'icloud': SimpleIcons.icloud,
    'digitalocean': SimpleIcons.digitalocean,
    'vercel': SimpleIcons.vercel,
    'netlify': SimpleIcons.netlify,
    'cloudflare': SimpleIcons.cloudflare,
    'railway': SimpleIcons.railway,
    'render': SimpleIcons.render,
    'supabase': SimpleIcons.supabase,
    'firebase': SimpleIcons.firebase,
    'mongodb': SimpleIcons.mongodb,

    // ── Communication & Meeting ───────────────────────────────
    'zoom': SimpleIcons.zoom,
    'discord': SimpleIcons.discord,
    'googlemeet': SimpleIcons.googlemeet,
    'webex': SimpleIcons.webex,

    // ── Payments & Finance ────────────────────────────────────
    'paypal': SimpleIcons.paypal,
    'stripe': SimpleIcons.stripe,
    'visa': SimpleIcons.visa,
    'mastercard': SimpleIcons.mastercard,
    'americanexpress': SimpleIcons.americanexpress,
    'amex': SimpleIcons.americanexpress,
    'gpay': SimpleIcons.googlepay,
    'googlepay': SimpleIcons.googlepay,
    'applepay': SimpleIcons.applepay,
    'samsungpay': SimpleIcons.samsungpay,
    'venmo': SimpleIcons.venmo,
    'cashapp': SimpleIcons.cashapp,
    'wise': SimpleIcons.wise,
    'revolut': SimpleIcons.revolut,
    // Indian
    'paytm': SimpleIcons.paytm,
    'phonepe': SimpleIcons.phonepe,
    'razorpay': SimpleIcons.razorpay,
    'zerodha': SimpleIcons.zerodha,

    // ── Gaming ────────────────────────────────────────────────
    'playstation': SimpleIcons.playstation,
    'steam': SimpleIcons.steam,
    'epicgames': SimpleIcons.epicgames,
    'roblox': SimpleIcons.roblox,
    'ea': SimpleIcons.ea,
    'ubisoft': SimpleIcons.ubisoft,
    'riotgames': SimpleIcons.riotgames,

    // ── Travel & Hospitality ──────────────────────────────────
    'airbnb': SimpleIcons.airbnb,
    'booking': SimpleIcons.bookingdotcom,
    'bookingcom': SimpleIcons.bookingdotcom,
    'expedia': SimpleIcons.expedia,
    'tripadvisor': SimpleIcons.tripadvisor,
    // Indian travel
    'oyo': SimpleIcons.oyo,

    // ── Education / Learning ──────────────────────────────────
    'udemy': SimpleIcons.udemy,
    'coursera': SimpleIcons.coursera,
    'skillshare': SimpleIcons.skillshare,
    'duolingo': SimpleIcons.duolingo,
    'khanacademy': SimpleIcons.khanacademy,

    // ── News & Reading ────────────────────────────────────────
    'medium': SimpleIcons.medium,
    'substack': SimpleIcons.substack,
    'wordpress': SimpleIcons.wordpress,
    'ghost': SimpleIcons.ghost,

    // ── Creators & Support ────────────────────────────────────
    'patreon': SimpleIcons.patreon,
    'kofi': SimpleIcons.kofi,
    'gumroad': SimpleIcons.gumroad,
    'onlyfans': SimpleIcons.onlyfans,
    'buymeacoffee': SimpleIcons.buymeacoffee,

    // ── AI Tools ──────────────────────────────────────────────
    'anthropic': SimpleIcons.anthropic,
    'claude': SimpleIcons.anthropic,
    'perplexity': SimpleIcons.perplexity,

    // ── Telecom (India) ───────────────────────────────────────
    'jio': SimpleIcons.jio,
    'airtel': SimpleIcons.airtel,
    'vodafone': SimpleIcons.vodafone,
    'vi': SimpleIcons.vodafone,

    // ── Automotive ────────────────────────────────────────────
    'tesla': SimpleIcons.tesla,
    'bmw': SimpleIcons.bmw,
    'audi': SimpleIcons.audi,
    'toyota': SimpleIcons.toyota,
    'honda': SimpleIcons.honda,
    'hyundai': SimpleIcons.hyundai,
    'ford': SimpleIcons.ford,
    'volkswagen': SimpleIcons.volkswagen,
    'porsche': SimpleIcons.porsche,
    'ferrari': SimpleIcons.ferrari,
    'lamborghini': SimpleIcons.lamborghini,

    // ── Energy / Fuel ─────────────────────────────────────────
    'shell': SimpleIcons.shell,

    // ── CRM / Enterprise ──────────────────────────────────────
    'hubspot': SimpleIcons.hubspot,
    'zendesk': SimpleIcons.zendesk,
    'intercom': SimpleIcons.intercom,

    // ── Misc ──────────────────────────────────────────────────
    'grammarly': SimpleIcons.grammarly,
    'lastpass': SimpleIcons.lastpass,
    'nordvpn': SimpleIcons.nordvpn,
    'expressvpn': SimpleIcons.expressvpn,
  };
}
