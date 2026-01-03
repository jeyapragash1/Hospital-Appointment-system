# Hospital Appointment Booking System

A lightweight Java web application (JSP/Servlet + JDBC) for managing hospital appointments between patients and doctors.

This README documents how to set up and run the project as it exists in the repository (NetBeans/Ant layout), plus important security and development notes.

## Quick overview
- Web UI: JSP pages under `web/`
- Server code: Java servlets and helpers under `src/java/com/hospitalappointment/`
- Build/project: NetBeans (Ant) configuration in `nbproject/`
- Database: MySQL (schema & sample data in `hospitalappointmentsystem.sql`)

## Features
- Patient registration and login
- Book, reschedule and cancel appointments
- Doctor and department management (admin pages)
- Appointment history views
- Simple payment recording (demo/testing only)

## Technology (actual)
- Front-end: HTML, CSS, Bootstrap, JSP
- Back-end: Java Servlets (no Spring framework)
- Data access: plain JDBC (no Hibernate/ORM)
- Database: MySQL

## Setup — database
1. Import the schema and sample data in `hospitalappointmentsystem.sql` into your MySQL server. Example (MySQL CLI):

```sql
SOURCE hospitalappointmentsystem.sql;
```

2. Update database credentials before running in production. The project attempts a JNDI DataSource lookup at `java:comp/env/jdbc/hospitalappointmentsystem` (see `web/META-INF/context.xml`). If absent, it falls back to a DriverManager connection — edit `src/java/com/hospitalappointment/DatabaseConnection.java` or `web/META-INF/context.xml` accordingly.

## Running locally (NetBeans)
1. Open NetBeans → `File` → `Open Project...` and select the project folder.
2. Ensure a servlet container (Tomcat/GlassFish) is configured in NetBeans.
3. Ensure MySQL is running and `hospitalappointmentsystem` schema is imported.
4. Add required libraries to project classpath (see Dependencies below).
5. Run the project from NetBeans (it will deploy to the configured server).

## Dependencies
- MySQL Connector/J (Connector/J) — make sure `mysql-connector-java` JAR is on the classpath.
- jBCrypt (`org.mindrot.jbcrypt`) — project uses BCrypt for password hashing; include the JAR in project libraries.

## Security & important notes
- Passwords: The updated code uses BCrypt; ensure all passwords in the DB are bcrypt-hashed. Do not store plaintext passwords.
- Payments: The sample app historically stored full card data and CVV. For safety the code now masks card numbers and does not store CVV — this repository is NOT PCI-compliant. Integrate a secure, tokenizing payment gateway (Stripe, PayPal, etc.) for production.
- DB credentials: Do NOT use the MySQL `root` account in production. Configure a dedicated DB user and store credentials in `web/META-INF/context.xml` or environment variables.
- Avoid scriptlets: Many JSPs contain inline JDBC logic. For maintainability and security, move business logic into servlets/controllers and use JSP/EL + JSTL for views.

## Development suggestions (next steps)
1. Complete refactor to MVC: move DB logic out of JSPs to servlets or a service layer.
2. Add connection pooling (Tomcat DataSource or HikariCP) via `context.xml`.
3. Add input validation and output encoding to prevent XSS and injection.
4. Add CSRF tokens for state-changing forms.
5. Add basic unit/integration tests for core services (User, Appointment).

## Files of interest
- `web/` — JSP pages and static assets
- `src/java/com/hospitalappointment/` — servlets and helpers (login/register, DB connection)
- `web/META-INF/context.xml` — example JNDI DataSource
- `hospitalappointmentsystem.sql` — schema and sample data

## Contact
If you want me to make any of the suggested code changes (fix registration/login flow, refactor JSPs, remove remaining CVV storage, add DataSource setup, or add tests), tell me which task to start next.

Contact: kishojeyapragash15@gmail.com
