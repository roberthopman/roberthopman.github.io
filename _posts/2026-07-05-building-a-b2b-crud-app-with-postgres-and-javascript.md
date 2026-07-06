---
layout: post
title:  "Building a B2B CRUD app with Postgres and TypeScript"
excerpt: "A b2b crud app with postgres, node and typescript isn't that special"
tags: [javascript, typescript, postgresql, crud]
sidebar: b2b-crud-app
---

Why bother building a simple B2B CRUD app with Postgres and TypeScript? 

Well for example, time tracking and invoicing. It's a classic example.

What are the steps to build?

## Initial Steps 

{% for section in site.data.b2b-crud-app.sections -%}
- [{{ section.title }}]({{ section.anchor }})
{% endfor %}

Thats't it.

So let's start with the first step.

You can find the full source code in the [b2b-crud-app GitHub repository](https://github.com/roberthopman/b2b-crud-app).

## Step 1: Create a new project with Node.js

```bash
mkdir b2b-crud-app && cd b2b-crud-app
npm init --yes
npm install express pg
```

That gives you:
- [express](https://www.npmjs.com/package/express) — web server (routes, controllers, views)
- [pg](https://www.npmjs.com/package/pg) — PostgreSQL client for Node.js

More details on Express: 
- Routing (GET, POST, PUT, DELETE, etc.)
- Middleware pipeline (plug in functions that process requests)
- Request parsing (URL params, query strings, form data, JSON)
- Static file serving (CSS, JS, images)
- Response methods (send HTML, JSON, redirects, status codes)
- Template engine support (EJS, Pug, Handlebars)
- Error handling
- Sub-routers (mount groups of routes)

Source: [https://github.com/expressjs/express](https://github.com/expressjs/express)

So we could create a postgres database with: 
```bash
createdb b2bapp
psql -d b2bapp
```

But we focus on the javascript part, less on the database part. 

We are looking for something that helps us with: 
- connect to the database
- create tables, columns and relationships
- create a mapping between the model and table
- create validations on the model

Comparing different ORMs with download trends:
```bash
for p in prisma typeorm sequelize knex objection; do
  curl -s "https://api.npmjs.org/downloads/point/last-week/$p" \
  | jq -r '[.downloads, .package] | @tsv'
done | sort -nr
8097784	prisma
3360833	knex
3345859	typeorm
2395864	sequelize
196709	objection
```

Visual comparison (compare it on the 5 year range): [https://npmtrends.com/knex-vs-objection-vs-prisma-vs-sequelize-vs-typeorm](https://npmtrends.com/knex-vs-objection-vs-prisma-vs-sequelize-vs-typeorm)

Lets use Prisma. We follow the quickstart: [https://www.prisma.io/docs/getting-started/prisma-postgres/quickstart/prisma-orm](https://www.prisma.io/docs/getting-started/prisma-postgres/quickstart/prisma-orm)

```bash
npm install typescript tsx @types/node --save-dev
npx tsc --init
```

That gives you:
- [typescript](https://www.typescriptlang.org/) — static typing for JavaScript
- [tsx](https://tsx.is/) — "TypeScript Execute", run TypeScript in Node
- [@types/node](https://www.npmjs.com/package/@types/node) — TypeScript definitions for Node.js

Why use typescript?

Plain javascript (in node)
```javascript
let var1 = "Hello";
var1 = 10;
console.log(var1);
=> 10
```

Typescript code:
```javascript
let var1: string = "Hello"; 
var1 = 10; 
console.log(var1);
=> Type 'number' is not assignable to type 'string'.
```

This helps catch type-related errors before your code runs, by enforcing type rules at compile time.

We covered:
```bash
npm install typescript tsx @types/node --save-dev
```

Lets continue:

```bash
npx tsc --init
```
`npx` is a command that comes with npm. `npx tsx --init` creates a `tsconfig.json` file. This file is used to configure the typescript compiler.
More details on the compiler options: [https://www.typescriptlang.org/tsconfig](https://www.typescriptlang.org/tsconfig)

Next, we're going to add Prisma:
```bash
npm install prisma @types/node @types/pg --save-dev
```

This gives you:
- [prisma](https://www.prisma.io/docs/reference/api-reference/command-reference) — The Prisma CLI for running commands like `prisma init`, `prisma migrate`, and `prisma generate`
- [@types/node](https://www.npmjs.com/package/@types/node) — TypeScript definitions for Node.js
- [@types/pg](https://www.npmjs.com/package/@types/pg) — TypeScript definitions for Postgres

Next, we're going adding the adapter:
```bash
npm install @prisma/client @prisma/adapter-pg dotenv
```

This gives you:
- [@prisma/client](https://www.npmjs.com/package/@prisma/client) — Prisma Client library for querying your database
- [@prisma/adapter-pg](https://www.npmjs.com/package/@prisma/adapter-pg) — The node-postgres driver adapter that connects Prisma Client to your database
- [dotenv](https://www.npmjs.com/package/dotenv) — Loads environment variables from your `.env` file

More on the interactions between the client library, query engine, database driver and database here: [https://www.prisma.io/docs/orm/overview/databases/database-drivers#driver-adapters](https://www.prisma.io/docs/orm/overview/databases/database-drivers#driver-adapters)

As a sidenote: Add an `.env.example` that isn't in the gitignore to have a document for showing structure of the `.env` .

Update `tsconfig.json` to be ESM compatible:

```json
{
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ES2023",
    "strict": true,
    "esModuleInterop": true,
    "ignoreDeprecations": "6.0"
  }
}
```

Quick note on ECMAScript Modules (ESM):
- Loading: ESM is asynchronous (better performance); CommonJS (CJS) is synchronous (can block execution).
- Syntax: ESM uses `import` and `export`; CJS uses `require` and `module.exports`.

Update `package.json` to enable ESM: `"type": "module",`.

## Step 2: Create a PostgreSQL database

Use: `npx prisma init --datasource-provider postgresql --output ../generated/prisma`, instead of the in the quickstart given `npx prisma init --db --output ../generated/prisma`.

For the `init --db` option: You'll be navigated to setup an online postgres database instance inside prisma.io. I completed the setup and that seems to work. We'll focus on offline-first development, so we move to Docker to not be bothered by changing postgres versions locally (when you have multiple projects).

So the above command creates:

- Creates a prisma/ directory with a schema.prisma file containing your database connection and schema models
- Creates a .env file in the root directory for environment variables
- Generates the Prisma Client in the generated/prisma/ directory
- Creates a prisma.config.ts file for Prisma configuration

Copy paste the content to `prisma.config.ts`:

```js
import 'dotenv/config'
import { defineConfig, env } from 'prisma/config'

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
  },
  datasource: {
    url: env('DATABASE_URL'),
  },
})
```

For better editing of your `schema.prisma` file, consider installing a [Prisma schema syntax highlighting extension for Cursor/VSCode](https://open-vsx.org/extension/Prisma/prisma).

As someone might already have homebrew running on 5432, we might want to use port 5433 for now:

- Homebrew PostgreSQL   ▶  port 5432  (local process)
- Docker container      ▶  port 5433  (host) ▶ 5432 (inside container)

The ports mapping "5433:5432" means:

```
host : port inside container
5433 : 5432
```

So, we'll try to run with docker via a `docker-compose.yml`:

```sh
services:
  db:
    image: postgres:18
    environment:
      POSTGRES_USER: postgresuser
      POSTGRES_PASSWORD: postgrespass
      POSTGRES_DB: b2bapp_dev
    ports:
      - "5433:5432"
    volumes:
      - db_data:/var/lib/postgresql

volumes:
  db_data:
```

To run it: `docker compose up -d`
- up — starts the services
- -d — detached (runs in background)

To stop it: `docker compose down`

We can list the process status (ps): `docker ps` 

We can list all the tables: `docker exec b2b-crud-app-db-1 psql -U postgresuser -d b2bapp_dev -c '\dt'`

We change .env to: 
`DATABASE_URL="postgresql://postgresuser:postgrespass@localhost:5433/b2bapp_dev?schema=public"`

And in a GUI:

- Host:     localhost
- Port:     5433
- User:     postgresuser
- Password: postgrespass
- Database: b2bapp_dev  

That works.

We've completed step 2: create a PostgreSQL database.

## Step 3: Create table, with foreign keys and constraints

### Step 3a: Create a table with columns

We see we can simply paste the data models to the schema.prisma file, lets do that.

The example that is given:
```js
model User {
  id    Int     @id @default(autoincrement())
  email String  @unique
  name  String?
  posts Post[]
}

model Post {
  id        Int     @id @default(autoincrement())
  title     String
  content   String?
  published Boolean @default(false)
  author    User    @relation(fields: [authorId], references: [id])
  authorId  Int
}
```

What does a model do exactly in Prisma?

A model has two major functions with Prisma:
- Represent a table in relational databases
- Provide the foundation for the queries in the Prisma Client API

So what kind of models and related tables would be useful in a b2b crud app? 
- User
- Project
- Project Members (join table, also called memberships)

Possible extensions: projects can be billable or not.

Now that we're here, lets also capture step 3b and 3c:

### Step 3b: Create a table with foreign keys, defaults and constraints
### Step 3c: Create a model that relates to a table

The data model:
```js
model User{
  id          Int             @id @default(autoincrement())
  email       String          @unique
  first_name  String?
  last_name   String?
  memberships ProjectMember[]
  createdAt   DateTime        @default(now())
}

model Project {
  id        Int             @id @default(autoincrement())
  name      String
  members   ProjectMember[]
  billable  Boolean         @default(true)
  createdAt DateTime        @default(now())
}

model ProjectMember {
  id        Int      @id @default(autoincrement())
  role      String   @default("member")
  user      User     @relation(fields: [userId], references: [id])
  userId    Int
  project   Project  @relation(fields: [projectId], references: [id])
  projectId Int
  createdAt DateTime @default(now())

  @@unique([userId, projectId])
}
```

We observe models with camelCase naming, the attributes, datatypes, primary key (@id), autoincrement, relations and (@@unique) constraint.

Note that both sides of a relation must be defined in the schema. So, the User must have the reverse relation memberships and the Project must have the relation of members.

So, lets do the first migration to setup the database tables:

`npx prisma migrate dev --name init`

Output:
```sh
Prisma schema loaded from prisma/schema.prisma.
Datasource "db": PostgreSQL database "postgres", schema "public" at "db.prisma.io:5432"

Applying migration `20260212211743_init`

The following migration(s) have been created and applied from new schema changes:

prisma/migrations/
  └─ 20260212211743_init/
    └─ migration.sql

Your database is now in sync with your schema.
```

Checking: `docker exec b2b-crud-app-db-1 psql -U postgresuser -d b2bapp_dev -c '\dt'`

```sh
                   List of tables
 Schema |        Name        | Type  |    Owner     
--------+--------------------+-------+--------------
 public | Project            | table | postgresuser
 public | ProjectMember      | table | postgresuser
 public | User               | table | postgresuser
 public | _prisma_migrations | table | postgresuser
(4 rows)
```

Done.

Now run: `npx prisma generate` and you'll see the directory being generated.

Then, we'll connect the ORM driver adapter to the client library.

```js
// lib/prisma.ts
import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../generated/prisma/client";

const connectionString = `${process.env.DATABASE_URL}`;

const adapter = new PrismaPg({ connectionString });
const prisma = new PrismaClient({ adapter });

export { prisma };
```

Note that `import { prismaPg }` is a deconstructoring import, it pulls the `prismaPg` function out of the `@prisma/adapter-pg` package and assigns it to the `adapter` variable.

Also note that in startup, `lib/prisma.ts` does the following:
  - Loads DATABASE_URL from `.env`
  - Creates the Prisma adapter
  - Exports a single `prisma` instance

Per Request Flow (ASCII Sequence Diagram) with prisma.user.findMany():
```sh
  +--------+        +--------+          +--------+           +-------------+
  | Client |        | Server |          | Prisma |           | PostgreSQL  |
  +--------+        +--------+          +--------+           +-------------+
      |                  |                   |                     |
      |   HTTP request   |                   |                     |
      |----------------->|                   |                     |
      |                  |                   |                     |
      |                  |  prisma.user      |                     |
      |                  |    .findMany()    |                     |
      |                  |-----------------> |                     |
      |                  |                   |     SQL query       |
      |                  |                   |-------------------> |
      |                  |                   |                     |
      |                  |                   |   Query result      |
      |                  |                   |<------------------- |
      |                  |  user list/data   |                     |
      |                  |<----------------- |                     |
      |      HTTP        |                   |                     |
      |     response     |                   |                     |
      |<-----------------|                   |                     |
      |                  |                   |                     |
```

Step 3c is done. 

### Step 3d: REPL

We have 3 models (User,Project,ProjectMember) and a generated Prisma client. 

With `npx tsx --interactive` we open a Node.js REPL with TypeScript support. From there we can import the Prisma client and query the models directly.

```js
const { prisma } = await import("./lib/prisma.js")
const u = prisma.user;
await u.findMany();
await u.create({ data: { email: "bob@example.com", first_name: "Bob" } });
await u.findMany({ include: { memberships: { include: { project: true } } } });
```

First, it's a destructuring import. Then assigns the `prisma` export out of `lib/prisma.ts` to the `u` variable.

As a side note, these two import statements are equivalent:
```js
// destructuring extracts `prisma` directly
const { prisma } = await import("./lib/prisma.js")

// without destructuring
const module = await import("./lib/prisma.js")
const prisma = module.prisma
```
It works because `lib/prisma.ts` ends with `export { prisma }`, which is a named export.

Side note: what does `await` do?

Await is an operator that is used to wait for a Promise to resolve.

More details: 

- [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await)
- [https://nodejs.org/learn/asynchronous-work/discover-promises-in-nodejs](https://nodejs.org/learn/asynchronous-work/discover-promises-in-nodejs)
- [https://v8.dev/blog/fast-async](https://v8.dev/blog/fast-async)

If you want to add a new model, the steps are:
1. Add the model to prisma/schema.prisma
2. Run `npx prisma migrate dev --name add_your_model`
3. Import prisma in the REPL and query it

The quickstart wraps up with a script.ts file, which we create in the b2b-crud-app project: [https://www.prisma.io/docs/prisma-postgres/quickstart/prisma-orm](https://www.prisma.io/docs/prisma-postgres/quickstart/prisma-orm)

To run the script:
```bash
# This creates a new user and a new project, and adds the user to the project as a member.
npx tsx script.ts 

# This deletes all data and resets the schema.
npx prisma migrate reset --force

# This opens the Prisma Studio GUI for browsing and editing the data.
npx prisma studio
```

## Step 4: Test driven development of the Create functionality in CRUD

Right now the models are schema: structure without behavior. 

In an ORM (like ActiveRecord in Rails), the model class holds both structure (the table and columns) and behavior (validations (rules), scopes (querying), and public/private functionality). 

Prisma deliberately splits them: the schema is structure-only.

So what goes between the request and the model? Lets explore different approaches.

### Stage 1: Inline route handler

One file, no separation. It does HTTP, route mapping, controller logic, business logic and query.

The idea: Request -> Route handler (does HTTP + business logic + query) -> Prisma -> Postgres

```js
  app.get("/users", async (req, res) => {
    const users = await prisma.user.findMany();   // Query right here
    res.json(users);
  });
```

### Stage 2: Add a service
  
Business logic now lives outside the route in a service, so it's reusable and testable.

The idea: Request -> Route -> Service -> Prisma -> Postgres

```js
// Service
export async function getUsers() {
  return prisma.user.findMany();
}

// Route
app.get("/users", async (req, res) => {
  res.json(await getUsers());
});
```

### Stage 3: Split route from controller

The route only maps URLs; the controller handles requests.

The idea: Request -> Route -> Controller -> Service -> Prisma -> Postgres

```js
// Service (Exists in Stage 2)
export async function getUsers() {
  return prisma.user.findMany();
}

// Controller
export async function listUsers(req, res) {
  res.json(await getUsers());
}

// Route
app.get("/users", listUsers);
```

### Stage 4: Full stack with repository

The repository only deals with data access.

The idea: Request -> Route -> Controller -> Service -> Repository -> Prisma -> Postgres

```js
// Repository — data access only
export const userRepo = {
  findAll: () => prisma.user.findMany(),
};
// Service — business logic, calls repository
export async function getUsers() { 
  return userRepo.findAll(); 
}

// Controller — req/res
export async function listUsers(req, res) { 
  res.json(await getUsers()); 
}

// Route — URL mapping
app.get("/users", listUsers);
```

In summary:

- Route decides: Which function handles this URL?
- Controller decides: How do I handle this HTTP request?
- Service decides: What business operation should happen?
- Repository decides: How do I get/save data?

We'll want a plain CRUD controller, service, repository and route.

- show a single user
- list all users
- create a user
- update a user
- delete a user

We'll want to create a user controller, with a service, repository and route.

Seems like a good starting point for a testing first approach:
- write a test
- write the code to make the test pass
- simplify
- repeat

Looking at vitest vs jest, [vitest](https://github.com/vitest-dev/vitest) looks promising: [https://npmtrends.com/jest-vs-vitest](https://npmtrends.com/jest-vs-vitest)

```sh
npm install -D vitest
```

We setup a `vitest.config.ts` with two type of test projects, one with mocks and one that touches the database (which is slow). We can now run them with `npm run test:unit` for the mocks, and `npm run test:db` for the database.

Available test commands:
- npm test
- npm run test:unit
- npm run test:db
- npm run test:watch

The one-time test-DB setup (which Prisma actually takes care of as well): `docker exec b2b-crud-app-db-1 psql -U postgresuser -d postgres -c 'CREATE DATABASE b2bapp_test;'`

And this command:
`DATABASE_URL="postgresql://postgresuser:postgrespass@localhost:5433/b2bapp_test?schema=public" npx prisma migrate deploy`

That seems like something recurring, we'll automate that: `npm install -D dotenv-cli`. 

We'll also add to the scripts: 
1. For development, `npm run db:migrate` which will read from `.env`.
2. For test, `db:test:migrate": "dotenv -e .env.test -- prisma migrate deploy`. So for applying migrations to test db, we now run `npm run db:test:migrate`.

We approach it as follows:

```md
#   Action   Function              Test                                  Suite   Expected
--  ------   --------------------  ------------------------------------  ------  ----------------------------
1   Create   createUser            rejects invalid email                 unit    throws /email/
2   Create   createUser            persists a valid user                 db      row saved, id assigned
3   Create   createUser            rejects duplicate email               db      throws (unique constraint)
4   Read     listUsers             returns [] when empty                 db      []
5   Read     listUsers             returns all users                     db      array of saved rows
6   Read     getUser               returns user + memberships            db      user, memberships: []   ✓ written
7   Read     getUser               returns null when missing             db      null                    ✓ written
8   Update   updateUser            rejects invalid email                 unit    throws /email/, no DB call
9   Update   updateUser            updates fields of existing user       db      changed row persisted
10  Update   updateUser            on missing id                         db      throws (record not found)
11  Delete   deleteUser            removes the user                      db      row gone (getUser → null)
12  Delete   deleteUser            on missing id                         db      throws (record not found)
```

Now we have to decide on architecture of organizing files, two acceptable choices here:
- layer based (routes/(users/projects/etc))
- feature based (/users/(routes/controllers/services/repositories/etc))

Have a look at these references: 
- [Screaming Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html)
- [Vertical Slice vs Clean Architecture by Nadir Bad](https://nadirbad.dev/vertical-slice-vs-clean-architecture)

We'll stick to layer based for now.

We start with nr. 1, the validation logic.

We add the `./test/userService.unit.test.ts`.

```js
import { describe, it, expect, vi } from "vitest";

// Mock Prisma so this unit test never opens a DB connection.
// Validation runs before any DB call, so a bare spy is enough.
vi.mock("../lib/prisma", () => ({
  prisma: { user: { create: vi.fn() } },
}));

// for now we'll add these two lines here
import { createUser } from "../services/userService";
import { prisma } from "../lib/prisma";

describe("createUser (unit)", () => {
  // #1 — validation logic, no DB
  it("rejects an invalid email", async () => {
    // Call createUser with an invalid email. 
    // I expect the returned Promise to reject, and the error message should contain the string invalid email, case-insensitive.
    await expect(createUser({ email: "not-an-email" })).rejects.toThrow(/invalid email/i);

    expect(prisma.user.create).not.toHaveBeenCalled();
  });
});
```

So, what test #1 expects of createUser:

- exists as a named export from ../services/userService
- takes one object argument with a string `email` field
- returns a Promise
- when `email` doesn't look like an email, the Promise rejects with an Error whose message contains "invalid email" (case-insensitive)
- we also expect that the database call is not made.

TDD becomes:

Action 1: Write the test. Then run `npm test` (or `npm run test:unit`) and it fails in red, that's good.
Feedback: red: "Cannot find module ../services/userService"

Action 2: Create `userService.ts` (empty)      
Feedback: red: "createUser is not a function"

Action 3: Add stub `export async function createUser() { return; }`
Feedback: red: 'promise resolved "undefined" instead of rejecting'

Action 4: Add the `input` param and guard `isValidEmail`
Feedback: red: AssertionError: expected [Function] to throw error matching /invalid email/i but got 'isValidEmail is not defined'
```js
// we create the input parameters
export type CreateUserInput = {
  email: string;
  first_name?: string;
  last_name?: string;
};

export async function createUser(input: CreateUserInput) {
  if (!isValidEmail(input.email)) {
    throw new Error(`Invalid email: ${input.email}`);
  }
}
```

Action 5: Define the isValidEmail regex helper.
Feedback: green 1 passed test

To be fair, we don't need to add the test the database call, because the test is testing the validation logic.

Now #2: saving a user to the database which means: persistence.

To begin, we have `test/setup.db.ts` that exists to truncate tables before each testrun.
We might have saved something while testing #1. 
Before we start, run `npm run db:test:migrate` to clear up the db.
That enables us to start with testing:

Action 1: write the test and run `npm run db:test`
Feedback: green 1 passed test

That is correct, in `userService.ts` we already had `return prisma.user.create({ data: input });`.

Now #3: reject duplicate emails

As we're talking to the db, in the same file we can write the next test.

Action 1: create the test run `npm run test:db`
Feedback: green 2 passed tests

So at this point we have the following tests:
- createUser rejects invalid email
- createUser rejects duplicate email
- createUser persists a valid user

As discussed before, we want to have have the following architecture:

- Service: decide and coordinate business behavior
- Repository: fetch and persist domain data

Now we start the refactor and introduce the repository.

This is the classic TDD cycle: 

1. red: think about the problem before you write code (and write a test instead!)
2. green: Make it work (and write the code to make the test pass)
3. refactor: Make it right (and improve the code without changing the behavior)

So a minimal user repository create function would be:
```js
create: (data) => prisma.user.create({ data })
```
But this line won't compile in TypeScript with strict mode enabled (in tsconfig.json) because the type of `data` is not specified. TypeScript requires explicit typing for function parameters in strict mode.

```js
create: (data: any) => prisma.user.create({ data })
```
This compiles but throws away all editor safety.

So the minimum required is "some type on data." Given you have to write something, Prisma.UserCreateInput is the least-work, most-honest choice — you're not inventing a shape, you're pointing at the one Prisma already defined from your schema.prisma.

```js
create: (data: Prisma.UserCreateInput) => prisma.user.create({ data })
```

Action: Create repositories/userRepo.ts with `create: (data: Prisma.UserCreateInput) => prisma.user.create({ data })`.
Feedback: green 

Action: import the repository in the service and change line `prisma.user.create(...)` → `userRepo.create(input)`.
Feedback: green

So we have:
- a service that can create a user
- a repository that can create a user
- a test suite that can test the create functionality

We are missing how to actually call the API from a client (for example a browser, or a mobile app).

So, let's integrate the service into a controller, and the controller into a route. So that we can create a user via a CURL request, as we're first building an API.

What to add next:

- controllers/userController.ts
- routes/users.ts
- app.ts
- server.ts

We split `app.ts` from `server.ts` because `app.ts` defines the Express application, while `server.ts` starts listening on a port. That makes the app easier to test later, because tests can import the Express app without starting a real server. 

Use TypeScript types for req and res: `import type { Request, Response } from "express";`
This tells TypeScript that `req` is an Express request and `res` is an Express response.
So first we'll add `npm install -D @types/express` to our dev dependencies.

For createUser, that looks like:

```js
// controllers/userController.ts
import type { Request, Response } from "express";
import { createUser } from "../services/userService";

export async function createUserHandler(req: Request, res: Response) {
  try {
    const user = await createUser(req.body);
    res.status(201).json(user);
  } catch (err) {
    // Plain Error has no code property. 
    // Prisma unique-constraint failures throw PrismaClientKnownRequestError.
    // This extends Error and adds code (e.g. "P2002"). 
    if (err instanceof Prisma.PrismaClientKnownRequestError && err.code === "P2002") {
      return res.status(409).json({ error: err.message });
    }
    if (err instanceof Error && /invalid email/i.test(err.message)) {
      return res.status(400).json({ error: err.message });
    }

    res.status(500).json({ error: "Internal server error" });
  }
}

// routes/users.ts
import { Router } from "express";
import { createUserHandler } from "../controllers/userController";

const router = Router();

router.post("/", createUserHandler);

export default router;

// app.ts
import express from "express";
import usersRouter from "./routes/users";

const app = express();

app.use(express.json());
app.get("/", (_req, res) => res.send("b2b-crud-app is running."));
app.use("/users", usersRouter);

export default app;

// server.ts
import app from "./app";

const port = 3000;

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
```

Add a dev script to run the server via tsx so you don't need to compile:

```json
"scripts": {
  "dev": "tsx watch server.ts"
}
```

So, we also want to ensure the HTTP requests are working as expected. We will use [supertest](https://www.npmjs.com/package/supertest) to test the HTTP requests.

Also, supertest is plain JavaScript and ships no TypeScript types. TypeScript therefore treats the import as any. `@types/supertest` is the community type package that declares supertest's API so imports like import request from "supertest" type-check correctly.

```sh
npm install -D supertest
npm install --save-dev @types/supertest
```

We'll add our new file: `test/http.users.db.test.ts`.

We add the following 4 tests:
- GET / returns 200 with the landing message
- POST /users creates a user (201)
- POST /users rejects invalid email (400)
- POST /users returns 409 for a duplicate email (conflict error)

We can run the tests with `npm run test:db`, and they should all be green. 

We're 'done' with the Create part.