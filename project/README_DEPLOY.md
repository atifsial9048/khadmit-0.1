# Deployment Instructions

## GitHub
1. Create a new GitHub repository for this project.
2. In the project folder, initialize Git locally when `git` is available:

   ```powershell
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/<your-username>/<repo-name>.git
   git push -u origin main
   ```

## Vercel
1. Sign in to Vercel and import the GitHub repository.
2. Use the default project settings; the root directory is the project root.
3. Set the build command to `npm run build` and the output directory to `dist`.
4. Add the required environment variables in Vercel's project settings.

## Chosen database provider
This project is wired for Supabase as the database provider.

### Why Supabase
- Cloud-hosted PostgreSQL
- Secure server-side access through service role keys
- Works well with Vercel serverless functions
- Simple row-level security and profile storage

### Required environment variables
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `VITE_API_BASE_URL=/api`

## Database schema
Use `supabase_schema.sql` to create the `profiles` table in your Supabase project.

## Local development
For the frontend, continue using:

```powershell
npm run dev
```

To test serverless API functions locally, install the Vercel CLI and run:

```powershell
npm install -g vercel
vercel dev
```

## Backend API
The project now includes:
- `/api/signup` — create a new user and profile
- `/api/signin` — authenticate a user and load profile data

## Important security note
Do not store the Supabase service role key in frontend code. Use it only on the server side (Vercel environment variables or local `.env.local`).
