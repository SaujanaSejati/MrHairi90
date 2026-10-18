# IlmuQuest 🎮📚

IlmuQuest ialah prototaip permainan pembelajaran berkonsep pengembaraan. Projek ini menggunakan Flutter untuk aplikasi Android dan Supabase untuk backend.

## Kandungan
- `flutter_app/`: kod sumber aplikasi Flutter
- `supabase/schema.sql`: skema database dan polisi Row Level Security (RLS)
- `.github/workflows/build-android.yml`: workflow untuk membina APK Android melalui GitHub Actions

## Status
Ini ialah MVP awal. Integrasi backend perlu diuji pada projek Supabase sebenar sebelum digunakan oleh pemain. Fungsi pemarkahan selamat di server, panel admin penuh dan grafik 3D masih memerlukan pembangunan lanjut.

## Persediaan Supabase
1. Cipta projek di https://supabase.com/
2. Semak dan jalankan `supabase/schema.sql` melalui SQL Editor.
3. Dalam GitHub repository Settings → Secrets and variables → Actions, tambah:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Jangan masukkan service_role key dalam aplikasi Flutter atau repository.

## Bina APK
Selepas kod Flutter dimasukkan, jalankan workflow **Build Android APK** di tab Actions. APK hanya boleh dianggap berjaya apabila workflow selesai tanpa ralat.

## Nota keselamatan
Semak polisi RLS dan uji dengan akaun pengguna biasa serta admin. Jangan masukkan maklumat rahsia, kata laluan, atau service-role key ke dalam kod.
