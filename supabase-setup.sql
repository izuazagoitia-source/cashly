-- ============================================
-- CASHLY — Setup de base de datos Supabase
-- Ejecutar en: supabase.com/dashboard/project/zymvblvsuaeeslajgvgo/sql/new
-- ============================================

-- Habilitar UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── PERFILES DE USUARIO ──
CREATE TABLE IF NOT EXISTS profiles (
  id          UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email       TEXT,
  full_name   TEXT,
  avatar_url  TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── TRANSACCIONES ──
CREATE TABLE IF NOT EXISTS transactions (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name        TEXT NOT NULL,
  amount      NUMERIC NOT NULL,
  category    TEXT,
  type        TEXT CHECK (type IN ('ingreso','gasto')) NOT NULL,
  date        DATE DEFAULT CURRENT_DATE,
  icon        TEXT DEFAULT '💳',
  badge       TEXT DEFAULT 'badge-gray',
  status      TEXT DEFAULT 'ok',
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── PROPIEDADES ──
CREATE TABLE IF NOT EXISTS properties (
  id              UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id         UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  alias           TEXT NOT NULL,
  tipo            TEXT,
  uso             TEXT,
  direccion       TEXT,
  banco           TEXT,
  compra          NUMERIC DEFAULT 0,
  mercado         NUMERIC DEFAULT 0,
  arriendo        NUMERIC DEFAULT 0,
  tiene_cred      BOOLEAN DEFAULT FALSE,
  credito_orig    NUMERIC DEFAULT 0,
  tasa            NUMERIC DEFAULT 0,
  plazo_meses     INTEGER DEFAULT 0,
  pagadas         INTEGER DEFAULT 0,
  dia_pago        INTEGER,
  contrib         NUMERIC DEFAULT 0,
  exenta          BOOLEAN DEFAULT FALSE,
  genera_ingreso  BOOLEAN DEFAULT FALSE,
  anio_adq        INTEGER,
  gastos_mant     NUMERIC DEFAULT 0,
  rol             TEXT,
  tasacion_fiscal NUMERIC DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ── ACTIVOS EXTRA (vehículos, inversiones, efectivo, sociedades) ──
CREATE TABLE IF NOT EXISTS assets (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  tipo        TEXT NOT NULL, -- vehiculos, inversiones, efectivo, sociedades
  icon        TEXT DEFAULT '📦',
  nombre      TEXT NOT NULL,
  valor       NUMERIC DEFAULT 0,
  costo       NUMERIC DEFAULT 0,
  anio        INTEGER,
  genera_ingreso BOOLEAN DEFAULT FALSE,
  ingreso_mes NUMERIC DEFAULT 0,
  notas       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── PASIVOS ──
CREATE TABLE IF NOT EXISTS liabilities (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  tipo          TEXT NOT NULL, -- hipotecario, consumo, tarjeta, linea, personal
  nombre        TEXT NOT NULL,
  saldo         NUMERIC DEFAULT 0,
  saldo_inicial NUMERIC DEFAULT 0,
  cuota         NUMERIC DEFAULT 0,
  tasa          NUMERIC DEFAULT 0,
  plazo_total   INTEGER DEFAULT 0,
  pagadas       INTEGER DEFAULT 0,
  banco         TEXT,
  vence_dia     INTEGER,
  limite_linea  NUMERIC DEFAULT 0,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── SEGUROS ──
CREATE TABLE IF NOT EXISTS insurance (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  tipo          TEXT NOT NULL,
  nombre        TEXT NOT NULL,
  compania      TEXT,
  poliza_num    TEXT,
  objeto        TEXT,
  prima_mes     NUMERIC DEFAULT 0,
  prima_anual   NUMERIC DEFAULT 0,
  monto_aseg    NUMERIC DEFAULT 0,
  deducible     NUMERIC DEFAULT 0,
  frecuencia    TEXT DEFAULT 'mensual',
  dia_pago      INTEGER,
  inicio        DATE,
  vencimiento   DATE,
  renovacion    TEXT DEFAULT 'si',
  alerta_venc   INTEGER DEFAULT 30,
  alerta_pago   INTEGER DEFAULT 3,
  coberturas    TEXT[],
  notas         TEXT,
  telefono      TEXT,
  estado        TEXT DEFAULT 'activo',
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── PRESUPUESTOS ──
CREATE TABLE IF NOT EXISTS budgets (
  id        UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id   UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  icon      TEXT,
  name      TEXT NOT NULL,
  used      NUMERIC DEFAULT 0,
  limit_amt NUMERIC NOT NULL,
  color     TEXT DEFAULT '#2D7A58',
  bg        TEXT DEFAULT '#E8F3ED',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── PRÉSTAMOS ──
CREATE TABLE IF NOT EXISTS loans (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  direccion     TEXT CHECK (direccion IN ('otorgado','recibido')) NOT NULL,
  persona       TEXT NOT NULL,
  relacion      TEXT,
  motivo        TEXT,
  monto         NUMERIC DEFAULT 0,
  tasa          NUMERIC DEFAULT 0,
  plazo         INTEGER DEFAULT 1,
  dia_pago      INTEGER DEFAULT 30,
  tipo_pago     TEXT DEFAULT 'cuotas',
  garantia      TEXT DEFAULT 'Sin garantía',
  fecha_inicio  DATE DEFAULT CURRENT_DATE,
  estado        TEXT DEFAULT 'activo',
  cuotas_pagadas INTEGER DEFAULT 0,
  color         TEXT DEFAULT '#2D6CC0',
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── DATOS AFP ──
CREATE TABLE IF NOT EXISTS afp_data (
  id          UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  afp         TEXT DEFAULT 'AFP Habitat',
  fondo       TEXT DEFAULT 'C',
  saldo       NUMERIC DEFAULT 0,
  cotizacion  NUMERIC DEFAULT 0,
  comision    NUMERIC DEFAULT 1.27,
  anios_cot   INTEGER DEFAULT 0,
  nacimiento  DATE,
  sueldo      NUMERIC DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- ROW LEVEL SECURITY — cada usuario solo ve sus datos
-- ============================================
ALTER TABLE profiles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties   ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets       ENABLE ROW LEVEL SECURITY;
ALTER TABLE liabilities  ENABLE ROW LEVEL SECURITY;
ALTER TABLE insurance    ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets      ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans        ENABLE ROW LEVEL SECURITY;
ALTER TABLE afp_data     ENABLE ROW LEVEL SECURITY;

-- Políticas: cada usuario solo accede a sus propios datos
DO $$ 
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['transactions','properties','assets','liabilities','insurance','budgets','loans','afp_data'] LOOP
    EXECUTE format('CREATE POLICY "user_own_%s" ON %s FOR ALL USING (auth.uid() = user_id)', t, t);
  END LOOP;
END $$;

CREATE POLICY "user_own_profile" ON profiles FOR ALL USING (auth.uid() = id);

-- ============================================
-- FUNCIÓN: crear perfil + datos demo al registrarse
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE uid UUID := NEW.id;
BEGIN
  -- Perfil
  INSERT INTO profiles (id, email, full_name, avatar_url)
  VALUES (uid, NEW.email, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url')
  ON CONFLICT (id) DO NOTHING;

  -- Transacciones demo
  INSERT INTO transactions (user_id, name, amount, category, type, date, icon, badge, status) VALUES
    (uid, 'Sueldo ' || TO_CHAR(CURRENT_DATE,'Mon YYYY'), 1550000, 'Ingreso', 'ingreso', CURRENT_DATE, '💼', 'badge-green', 'ok'),
    (uid, 'Supermercado', -85000, 'Supermercado', 'gasto', CURRENT_DATE - 2, '🛒', 'badge-blue', 'ok'),
    (uid, 'Netflix', -15990, 'Entretenimiento', 'gasto', CURRENT_DATE - 5, '📺', 'badge-purple', 'ok'),
    (uid, 'Restaurante', -35000, 'Restaurantes', 'gasto', CURRENT_DATE - 7, '🍽️', 'badge-warn', 'ok');

  -- Presupuestos demo
  INSERT INTO budgets (user_id, icon, name, used, limit_amt, color, bg) VALUES
    (uid, '🏠', 'Hogar',         0, 200000, '#1B4F3A', '#E8F3ED'),
    (uid, '🛒', 'Supermercado',  85000, 200000, '#1A4E8A', '#E8F0FB'),
    (uid, '🍽️', 'Restaurantes',  35000, 150000, '#B7650A', '#FDF3E3'),
    (uid, '🚗', 'Transporte',    0, 100000, '#5B3FA8', '#F0ECFB'),
    (uid, '🎬', 'Entretenimiento', 15990, 80000, '#C0392B', '#FCEAEA');

  -- AFP demo vacío
  INSERT INTO afp_data (user_id, saldo, cotizacion, nacimiento)
  VALUES (uid, 0, 0, NULL)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$;

-- Trigger al crear usuario
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
