# Henry Mashen Masanja — Personal Website

A fast, static personal portfolio (single `index.html` + `images/` + `documents/`).
No build step — edit the HTML, push, and it's live.

Live site: **https://henrymashenmasanja.com** (after deploying — see below)

---

## Project structure

```
Website/
├── index.html          # the whole site (HTML + CSS + JS in one file)
├── images/             # photos used on the site (clean names) + originals
├── documents/          # CV, transcripts, certificates (PDFs)
├── Caddyfile           # web-server config for the VM (auto HTTPS)
├── deploy.sh           # run on the VM to publish the latest version
├── .gitignore
└── README.md
```

## Editing

Open `index.html` in your editor. Everything lives in that one file:
- **Text/sections** are plain HTML — edit in place.
- **Add a gallery photo:** drop the file in `images/`, then copy a `.gallery-tile`
  block in the `§ 06 Gallery` section and point `data-full` + `<img src>` at it.
- **Add a document:** drop the PDF in `documents/`, then copy a `.doc-card`
  block in `§ 07 Documents` and update the `href`.
- **Colors/theme:** the `:root` and `[data-theme="dark"]` CSS variables at the top.

Preview locally by double-clicking `index.html`, or run a local server:
```bash
python -m http.server 5500    # then open http://localhost:5500
```

---

## Going live at henrymashenmasanja.com

You need three things: **(1) a domain, (2) a server, (3) DNS pointing one at the other.**

### 1. Register the domain
Buy `henrymashenmasanja.com` from a registrar (Cloudflare or Porkbun recommended,
~$10/yr). Note: only YOU can buy this — it needs your payment.

### 2. Create the Oracle Cloud "Always Free" VM
1. cloud.oracle.com → **Compute → Instances → Create Instance**
2. Image **Ubuntu 22.04**, Shape **VM.Standard.A1.Flex** (Always Free eligible)
3. Download the SSH private key. Note the **public IP**.

### 3. Open the firewall (two layers — Oracle gotcha)
**Cloud side:** VCN → Security List → add Ingress rules for `0.0.0.0/0` on TCP **80** and **443**.
**VM side** (after SSH in):
```bash
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save
```

### 4. Install Caddy + clone the site (one-time)
SSH in (`ssh -i your-key.key ubuntu@YOUR_IP`):
```bash
sudo apt update && sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl git
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install -y caddy

# clone your repo into the web root
sudo git clone https://github.com/Chanx-Charitana/henrymashenmasanja.git /var/www/henry

# install the Caddy config
sudo cp /var/www/henry/Caddyfile /etc/caddy/Caddyfile
sudo systemctl reload caddy
```

### 5. Point the domain
At your registrar add **A records**:
```
@    ->  YOUR_VM_IP
www  ->  YOUR_VM_IP
```
Within minutes–hours, Caddy issues a free SSL cert and the site is live at
**https://henrymashenmasanja.com** 🔒

---

## Publishing updates (the everyday loop)

On your PC after editing:
```bash
git add -A
git commit -m "describe your change"
git push
```
Then on the VM (or via one SSH command):
```bash
ssh -i your-key.key ubuntu@YOUR_IP "cd /var/www/henry && ./deploy.sh"
```

That's it — edit, push, deploy.
