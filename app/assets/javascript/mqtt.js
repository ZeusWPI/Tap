import mqtt from "mqtt";

async function ready() {
  const el = document.getElementById("data-successful_order_items");
  if (!el)
    return;

  const items = JSON.parse(el.textContent);
  el.textContent = '[]';

  if (!Array.isArray(items))
    return;
  if (!items.length)
    return;

  let client = await mqtt.connectAsync('wss://mqtt.kelder.zeus.gent/');
  await client.publishAsync('frigo/ordered', JSON.stringify(items, null, 2), {qos: 2});
  await client.endAsync();
}

document.addEventListener("turbo:load", ready);
