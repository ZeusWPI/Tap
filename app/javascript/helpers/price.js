/**
 * Convert a price in cents to a formatted price in EUR.
 * @param {number} price_cents price in cents.
 */
export function formatPrice(price_cents) {
  return `€${(price_cents / 100.0).toFixed(2)}`;
}
