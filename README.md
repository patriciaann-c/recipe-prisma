# 🍳 Recipe Prisma DB

A sample relational recipe management database project (**Recipes**, **Ingredients**, and **Chefs**) built with **Node.js** (ES Modules), **Prisma ORM (v7)**, and **MySQL / MariaDB** via the official MariaDB Driver Adapter.

---

## 📋 Table of Contents

- [Key Features](#-key-features)
- [Database Architecture & Schema](#-database-architecture--schema)
  - [ER Diagram](#er-diagram)
  - [Entities & Relationships](#entities--relationships)
- [Prisma 7 Architecture & Highlights](#-prisma-7-architecture--highlights)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
  - [1. Install Dependencies](#1-install-dependencies)
  - [2. Environment Configuration](#2-environment-configuration)
  - [3. Create Database & Shadow Database](#3-create-database--shadow-database)
- [Running Database Migrations](#-running-database-migrations)
- [Available NPM Scripts](#-available-npm-scripts)
- [Testing & Usage Example](#-testing--usage-example)
- [License](#-license)

---

## ✨ Key Features

- **Prisma ORM v7**: Built on the latest major release with centralized configuration via `prisma.config.ts`.
- **Driver Adapter (`@prisma/adapter-mariadb`)**: Connects directly to MariaDB/MySQL with configurable connection pooling.
- **Relational Data Modeling**:
  - **One-to-Many** relationship (`Chef` ➡️ `Recipe`).
  - **Many-to-Many** relationship with an explicit join/pivot table (`Recipe` 🔄 `Ingredient` via `Ingredient_Recipe`).
  - **Native MySQL Enum** for recipe difficulty levels (`LOW`, `MEDIUM`, `HARD`).
- **ES Modules (ESM)**: Full `type: "module"` configuration supporting native `import/export` syntax and Top-Level `await`.

---

## 🗄️ Database Architecture & Schema

### ER Diagram

```mermaid
erDiagram
    Chef ||--o{ Recipe : "creates (1:N)"
    Recipe ||--o{ Ingredient_Recipe : "includes"
    Ingredient ||--o{ Ingredient_Recipe : "belongs to"

    Chef {
        int id PK
        string name
    }

    Recipe {
        int id PK
        string name
        string description
        enum difficulty
        int chefId FK
    }

    Ingredient {
        int id PK
        string name
        int quantity
        boolean contains_allergen
    }

    Ingredient_Recipe {
        int recipeId PK, FK
        int ingredientId PK, FK
    }
```

### Entities & Relationships

1. **`Chef`**:
   - `id`: Auto-incrementing primary key.
   - `name`: Chef's name.
   - Has a one-to-many relationship with `Recipe`.

2. **`Recipe`**:
   - `id`: Auto-incrementing primary key.
   - `name`: Recipe title.
   - `description`: Optional text description.
   - `difficulty`: Difficulty level via enum `Recipe_Status` (`LOW`, `MEDIUM`, `HARD`), defaulting to `MEDIUM`.
   - `chefId`: Foreign key pointing to `Chef`.
   - Linked to `Ingredient` records via the join table `Ingredient_Recipe`.

3. **`Ingredient`**:
   - `id`: Auto-incrementing primary key.
   - `name`: Ingredient name.
   - `quantity`: Quantity measurement.
   - `contains_allergen`: Boolean flag indicating allergen presence (defaults to `false`).

4. **`Ingredient_Recipe` (Pivot / Join Table)**:
   - Represents the explicit many-to-many relationship between `Recipe` and `Ingredient`.
   - Enforces uniqueness via the composite constraint `@@unique([recipeId, ingredientId])`.

---

## ⚡ Prisma 7 Architecture & Highlights

This project adopts modern architectural patterns introduced in **Prisma 7**:

1. **`prisma.config.ts`**:
   Connection strings are no longer embedded directly into `schema.prisma`. Instead, they are defined programmatically using `defineConfig` in the configuration file:
   - `datasource.url`: Used for migrations, introspection, and Prisma Studio.
   - `datasource.shadowDatabaseUrl`: Dedicated temporary database used internally by Prisma CLI during `prisma migrate dev` to safely detect migration drift and state changes.

2. **`prisma-client.js` with Driver Adapters**:
   At runtime, Prisma Client initializes using `@prisma/adapter-mariadb`. This provides granular control over database pool parameters (`host`, `port`, `user`, `password`, `connectionLimit`).

---

## 📂 Project Structure

```text
recipe-prisma/
├── prisma/
│   ├── migrations/          # Version-controlled SQL migration files
│   └── schema.prisma        # Prisma data models and enum definitions
├── .env                     # Local environment variables (git-ignored)
├── .env.example             # Template for required environment variables
├── .gitignore
├── package.json             # Dependencies and project scripts
├── pnpm-lock.yaml           # pnpm lockfile
├── prisma.config.ts         # Prisma 7 CLI configuration (URLs & shadow DB)
├── prisma-client.js         # Configured PrismaClient singleton with MariaDB adapter
├── test-db.js               # Sample script demonstrating queries and nested writes
└── README.md                # Project documentation
```

---

## 🛠️ Prerequisites

Before you start, make sure you have the following installed:
- **Node.js** (v18.x or later recommended)
- **pnpm** (recommended as defined in `devEngines`) or `npm`
- A running **MySQL** or **MariaDB** server (local instance, Docker container, or XAMPP/MAMP).

---

## 🚀 Installation & Setup

### 1. Install Dependencies

Clone or open the repository folder and install the required packages:

```bash
pnpm install
```

*(Or using npm: `npm install`)*

---

### 2. Environment Configuration

Create a local `.env` file by copying `.env.example`:

```bash
cp .env.example .env
```

Update `.env` with your actual MySQL/MariaDB credentials:

```env
# Prisma CLI connection string (used for migrations, studio, and schema operations)
DATABASE_URL="mysql://root:your_password@localhost:3306/recipe_db"

# Shadow database connection string (required by Prisma Migrate)
SHADOW_DATABASE_URL="mysql://root:your_password@localhost:3306/recipe_db_shadow"

# Runtime connection parameters used by @prisma/adapter-mariadb in prisma-client.js
DATABASE_HOST="localhost"
DATABASE_PORT="3306"
DATABASE_USER="root"
DATABASE_PASSWORD="your_password"
DATABASE_NAME="recipe_db"
```

> [!IMPORTANT]
> Ensure the database user has permissions to create, alter, read, and write tables across both databases.

---

### 3. Create Database & Shadow Database

Log into your MySQL/MariaDB instance (via CLI, phpMyAdmin, DBeaver, or MySQL Workbench) and create the primary and shadow databases:

```sql
CREATE DATABASE IF NOT EXISTS recipe_db;
CREATE DATABASE IF NOT EXISTS recipe_db_shadow;
```

---

## 🔄 Running Database Migrations

Apply the existing migrations from `prisma/migrations` to sync your database schema:

```bash
pnpm run migrate
```

This command runs all pending SQL migrations and automatically generates the updated Prisma Client.

---

## 📜 Available NPM Scripts

The following scripts are defined in `package.json`:

| Command | Script | Description |
| :--- | :--- | :--- |
| **`pnpm run validate`** | `prisma validate` | Validates the syntax of `schema.prisma`. |
| **`pnpm run migrate`** | `prisma migrate dev` | Applies pending migrations or generates a new one based on schema changes. |
| **`pnpm run generate`** | `prisma generate` | Generates the `@prisma/client` code. |
| **`pnpm run studio`** | `prisma studio` | Opens an interactive web GUI to inspect and manipulate data. |

---

## 🧪 Testing & Usage Example

A sample script is provided in [test-db.js](test-db.js).

It demonstrates:
1. Importing the configured Prisma singleton instance from [prisma-client.js](prisma-client.js).
2. Performing a **Nested Write** to create a new `Recipe` and its associated `Chef` in a single atomic transaction:
   ```javascript
   import { client } from "./prisma-client.js";

   const newRecipe = await client.recipe.create({
       data: {
           name: 'Spaghetti alla carbonara',
           description: 'Buonissima',
           difficulty: 'MEDIUM',
           chef: {
               create: {
                   name: "Patricia Ann"
               }
           }
       }
   });
   ```
3. Querying all recipes from the database:
   ```javascript
   const recipes = await client.recipe.findMany();
   console.log(recipes);
   ```

To run the test script:

```bash
node test-db.js
```

---

## 📄 License

This project is licensed under the **ISC** License.
