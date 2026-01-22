# Waybar Power ღილაკი — Inline Confirmation (TTL)

ეს ჰენდაუტი აღწერს **Waybar-ში power / reboot ღილაკის სწორ, არქიტექტურულად გამართულ რეალიზაციას**, ისე რომ:

- არ გაიხსნას ფანჯარა
- არ დაიფაროს ეკრანი
- კონფირმაცია მოხდეს **უშუალოდ ღილაკზე** (inline)
- UI არ გაიჭედოს
- გადატვირთვის შემდეგ არაფერი დარჩეს „YES?“ მდგომარეობაში

მიდგომა ეფუძნება **state + TTL (time-to-live)** მოდელს.

---

## 1. მთავარი იდეა

Waybar **ვერ ხატავს popup / dropdown / anchored ფანჯრებს**.
ამიტომ კონფირმაცია კეთდება ასე:

1. პირველი კლიკი → ღილაკი იცვლის ტექსტს (`⏻` → `YES?`)
2. მეორე კლიკი იმავე ღილაკზე, მცირე დროში → ქმედება (shutdown / reboot)
3. თუ დადასტურება არ მოხდა → მდგომარეობა ავტომატურად ქრება

ეს არის **Waybar-ის ფარგლებში შესაძლებელი მაქსიმუმი**.

---

## 2. ფაილების სტრუქტურა

ყველა სკრიპტი მდებარეობს:

```
~/.config/waybar/scripts/
```

გამოყენებული ფაილები:

- `power-render.sh` — ვიზუალური ნაწილი
- `power-action.sh` — shutdown ლოგიკა
- `reboot-action.sh` — reboot ლოგიკა

---

## 3. power-render.sh — ვიზუალური ლოგიკა (TTL-ით)

**ფაილი:**
```
~/.config/waybar/scripts/power-render.sh
```

**შინაარსი:**

```sh
#!/usr/bin/env sh

STATE="/tmp/waybar-power-confirm"
TTL=2   # წამებში

if [ -f "$STATE" ]; then
  NOW=$(date +%s)
  CREATED=$(stat -c %Y "$STATE")

  if [ $((NOW - CREATED)) -le $TTL ]; then
    echo '{ "text": "YES?", "tooltip": "Click again to shutdown", "class": "powermenu-confirm" }'
    exit 0
  else
    rm -f "$STATE"
  fi
fi

echo '{ "text": "⏻", "tooltip": "Power", "class": "powermenu" }'
```

### განმარტება

- კითხულობს state ფაილს
- ამოწმებს რამდენი დრო გავიდა
- თუ ვადა არ გასულა → აჩვენებს `YES?`
- თუ ვადა გავიდა → state იშლება და ბრუნდება `⏻`

**რატომ:**
UI არ უნდა იყოს მუდმივ confirmation მდგომარეობაში.

---

## 4. power-action.sh — shutdown ქცევა

**ფაილი:**
```
~/.config/waybar/scripts/power-action.sh
```

**შინაარსი:**

```sh
#!/usr/bin/env sh

STATE="/tmp/waybar-power-confirm"
TTL=2

if [ -f "$STATE" ]; then
  NOW=$(date +%s)
  CREATED=$(stat -c %Y "$STATE")

  if [ $((NOW - CREATED)) -le $TTL ]; then
    rm -f "$STATE"
    systemctl poweroff
    exit 0
  else
    rm -f "$STATE"
  fi
fi

touch "$STATE"
```

### განმარტება

- თუ მეორე კლიკი მოხდა TTL-ის ფარგლებში → shutdown
- თუ ვადა გასულია → state იშლება და თავიდან იწყება

**რატომ:**
confirmation უნდა იყოს დროებითი და პროგნოზირებადი.

---

## 5. reboot-action.sh — reboot ქცევა

**ფაილი:**
```
~/.config/waybar/scripts/reboot-action.sh
```

**შინაარსი:**

```sh
#!/usr/bin/env sh

STATE="/tmp/waybar-reboot-confirm"
TTL=2

if [ -f "$STATE" ]; then
  NOW=$(date +%s)
  CREATED=$(stat -c %Y "$STATE")

  if [ $((NOW - CREATED)) -le $TTL ]; then
    rm -f "$STATE"
    systemctl reboot
    exit 0
  else
    rm -f "$STATE"
  fi
fi

touch "$STATE"
```

⚠️ **შენიშვნა:** power და reboot ყოველთვის უნდა იყენებდეს **ცალკე state ფაილებს**.

---

## 6. უფლებების მინიჭება

ყველა სკრიპტი უნდა იყოს executable:

```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

---

## 7. Waybar კონფიგურაცია (Nix ფორმატი)

### modules-right

```nix
modules-right = [
  "cpu"
  "memory"
  "network"
  "custom/separator"
  "pulseaudio"
  "custom/separator"
  "battery"
  "custom/separator"
  "custom/kbd"
  "custom/separator"
  "custom/power"
];
```

### custom.power

```nix
custom.power = {
  exec = "~/.config/waybar/scripts/power-render.sh";
  return-type = "json";
  interval = 1;

  on-click = "~/.config/waybar/scripts/power-action.sh";
  on-click-right = "~/.config/waybar/scripts/reboot-action.sh";
};
```

### რატომ interval = 1

Waybar **pull-მოდელზე მუშაობს**.
`interval = 1` ნიშნავს, რომ ყოველ წამს ხელახლა წაიკითხავს ვიზუალურ მდგომარეობას.

---

## 8. საბოლოო ქცევა

- ⏻ — ნორმალური მდგომარეობა
- პირველი კლიკი → `YES?`
- მეორე კლიკი 2 წამში → shutdown / reboot
- თუ არ დაადასტურე → ავტომატურად ბრუნდება `⏻`
- reboot / shutdown შემდეგ **არაფერი რჩება stuck**

---

## 9. ძირითადი დასკვნები

- Waybar არ არის popup UI
- inline confirmation შესაძლებელია მხოლოდ **state + TTL** მოდელით
- UI ლოგიკა ყოველთვის `exec`-შია
- ქცევა ყოველთვის `on-click`-შია
- confirmation არასდროს უნდა იყოს მუდმივი მდგომარეობა

ეს გადაწყვეტა არის **სრული, დასრულებული და პრაქტიკაში გამართული**.

