# 🚀 Laravel Startup Script (with Dev Container)

This Bash script automates the setup of a fresh **Laravel** project using the official [Laravel Sail](https://laravel.com/docs/sail) Docker environment and configures it for development inside a **VS Code Dev Container**.

It installs helpful extensions, IDE helpers, and debugging tools automatically — saving you time and making sure every Laravel app is ready for development right away.

**HT**: Based on this blog article (with my own personal modifications): https://blog.devsense.com/2022/laravel-on-docker/

---

## 🧰 Features

✅ Automatically creates a new Laravel project via [laravel.build](https://laravel.build).  
✅ Configures a `.devcontainer/devcontainer.json` with:
- The **DEVSENSE PHP Tools** VS Code extension.
- A `postStartCommand` that automatically installs the [Laravel IDE Helper](https://github.com/barryvdh/laravel-ide-helper).
✅ Updates `composer.json` to run IDE Helper commands on each composer update.
✅ Enables **Xdebug** in the `.env` file for debugging inside VS Code.

---

## 🧩 Usage

### 1. Clone or download this script
```bash
git clone https://github.com/<your-username>/laravel-startup.git
cd laravel-startup
```

### 2. Make the script executable
```bash
chmod +x laravel-startup.sh
```

### 3. Run the script with your desired app name
```bash
./laravel-startup.sh my-laravel-app
```

This will:
- Create a new Laravel app named `my-laravel-app`
- Set up Sail and a Dev Container
- Configure IDE helpers and debugging automatically

---

## 🖥️ Opening in Visual Studio Code

Once the setup finishes:

1. Open the project folder in **VS Code**.
2. When prompted, click **“Reopen in Container”**.  
   VS Code will build and start the Docker container environment defined in `.devcontainer/devcontainer.json`.

---

## ⚙️ Post-Startup Setup (inside the container)

Once VS Code has reopened the project inside the container:

### In the terminal, run:
```bash
composer install
npm install
php artisan key:generate
php artisan migrate
php artisan serve
```

This will:
- Install PHP and JS dependencies
- Generate your application key
- Run any migrations
- Start the Laravel development server

---

## 🌐 Viewing Your App

By default, Sail runs your app on port **8000**.  
Once `php artisan serve` is running, open your browser and visit:

👉 [http://localhost:8000](http://localhost:8000)

You should see the default Laravel welcome page.

---

## 🧠 Notes

- The script enables **Xdebug** automatically for debugging with VS Code.  
- You can customize the dev container further in `.devcontainer/devcontainer.json`.  
- The `postStartCommand` installs `barryvdh/laravel-ide-helper` to improve PHP autocompletion and static analysis.

---

## 🧾 Example Output Summary

After running the script, your project will include:
```
my-laravel-app/
├── .devcontainer/
│   └── devcontainer.json   ← Auto-updated with extensions and postStartCommand
├── .env                    ← Updated with Xdebug settings
├── composer.json           ← Updated to include IDE helper post-update commands
├── vendor/
└── sail and docker setup files
```

---

## 🏁 Done!

You now have a **ready-to-code Laravel project** with:
- A fully configured Docker environment  
- IDE helper integration  
- Debugging support  
- Smart VS Code extensions  

Happy coding! 🎉
