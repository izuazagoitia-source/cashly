# Cashly — Finanzas Personales 🇨🇱

App de gestión patrimonial personal para Chile: balance, propiedades, seguros, jubilación y más.

---

## 🚀 Deploy en Vercel (gratis, 5 minutos)

### Opción A — Desde GitHub (recomendada)

1. **Sube este proyecto a GitHub**
   ```bash
   git init
   git add .
   git commit -m "Cashly v1.0"
   git branch -M main
   git remote add origin https://github.com/TU_USUARIO/cashly.git
   git push -u origin main
   ```

2. **Conecta con Vercel**
   - Ve a [vercel.com](https://vercel.com) y crea una cuenta gratuita
   - Haz clic en **"Add New Project"**
   - Selecciona el repositorio `cashly`
   - Vercel detecta automáticamente la configuración
   - Haz clic en **Deploy**
   - En ~60 segundos tienes tu URL: `https://cashly-xxx.vercel.app`

### Opción B — Vercel CLI (sin GitHub)

```bash
# Instalar Vercel CLI
npm install -g vercel

# Dentro de esta carpeta
vercel

# Seguir las instrucciones en pantalla
# Al final obtienes tu URL pública
```

---

## 💻 Correr localmente

```bash
npm install
npm start
# Abre http://localhost:3000
```

---

## 📁 Estructura del proyecto

```
cashly/
├── public/
│   ├── index.html                        # App completa (todos los módulos)
│   └── estado_situacion_financiera.pdf   # PDF estado de situación bancario
├── server.js                             # Servidor Express
├── package.json
├── vercel.json                           # Configuración Vercel
└── README.md
```

---

## 📦 Módulos incluidos

| Módulo | Descripción |
|--------|-------------|
| ⚖️ Balance Personal | Estado de situación financiera tipo empresarial |
| 🏠 Propiedades | Créditos hipotecarios, ROL SII, tasación fiscal |
| 🚗 Activos | Vehículos, inversiones, efectivo, sociedades |
| 📉 Pasivos | Hipotecas, consumo, tarjetas, líneas de crédito |
| 💵 Ingresos | Sueldos, arriendos, conciliación bancaria |
| 💸 Gastos | Categorías, fijos vs variables, tendencias |
| 🎯 Presupuestos | Metas mensuales con alertas |
| 🤝 Préstamos | Otorgados y recibidos, cuotas, intereses |
| 🧓 Jubilación | AFP, proyección, calculadora, APV, escenarios |
| 🛡️ Seguros | Pólizas, vencimientos, alertas, análisis |
| 📋 Transacciones | Libro mayor unificado ingresos + egresos |
| 📄 PDF | Estado de situación para banco con ROL y tasación |

---

## 🔮 Próximos pasos para producción

1. **Base de datos** — Agregar [Supabase](https://supabase.com) (gratis) para persistir datos por usuario
2. **Autenticación** — Login con email/RUT usando Supabase Auth
3. **Cartola automática** — Integrar [Fintoc](https://fintoc.com) para sincronización bancaria
4. **UF en tiempo real** — API pública CMF: `https://mindicador.cl/api/uf`
5. **Notificaciones** — Alertas de vencimiento de seguros y dividendos por email

---

## 🛠️ Stack técnico

- **Frontend**: HTML5 + CSS3 + JavaScript vanilla + Chart.js
- **Backend**: Node.js + Express
- **Host**: Vercel (gratuito)
- **PDF**: Generado con ReportLab (Python)

---

*Desarrollado con Claude · Mayo 2025*
