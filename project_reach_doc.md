# TUMex – Medical Equipment & Supplies Platform

## 🩺 Overview

**TUMex** is a platform for renting and selling medical equipment and supplies, designed for hospitals, clinics, and healthcare professionals.  
The platform streamlines the process of requesting, quoting, and managing medical resources, with key integrations like Google Calendar and automated email notifications.

---

## ⚙️ Tech Stack

### Frontend

- **Framework:** Flutter (Dart)
- **IDE:** Cursor
- **Cross-platform:** Android, iOS, Web, Desktop
- **State Management:** Provider/Riverpod
- **Package Management:** [pub.dev](https://pub.dev/)

### Backend

- **BaaS:** Firebase
  - **Authentication:** Email/password, Google, Apple, OAuth
  - **Database:** Cloud Firestore (NoSQL, real-time)
  - **Storage:** Firebase Storage
  - **Cloud Functions:** Business logic, automation, and integrations
  - **Cloud Messaging:** Push notifications
  - **Hosting:** For web resources, landing page, and documentation

### External Integrations

- **Google Calendar API:**
  - Event scheduling & synchronization with user calendars
- **Email Automation:**
  - Automatic sending of quotes, confirmations, and updates
- **Payments:** (Not decided yet, is a possibility)
  - Stripe, MercadoPago, Paypal
- **WhatsApp API:** (Not decided yet, is a possibility)
  - Quick notifications and sharing of quotes

### DevOps & Tooling

- **Version Control:** Git (GitHub/GitLab)
- **CI/CD:** GitHub Actions, Bitrise
- **Crash Reporting & Analytics:** Firebase Crashlytics & Analytics
- **Testing:** Flutter `test` package, integration testing

---

## 👥 User Modules

### 1. **App for Doctors/Clients**

#### **Main Users**

- Doctors
- Hospital Directors
- Clinic Admins

#### **User Flow**

1. **Sign up/Login**
   - Email and password only (no OAuth at this stage)
   - Password recovery via email

2. **Onboarding (Inbound)**
   - After first login, users fill out required info:
     - Full name
     - Medical specialty (optional)
     - Professional license (optional)
     - Phone
     - Email (pre-filled, locked)
     - Clinic/hospital name (optional)
     - Position/role (doctor, surgeon, admin, etc.)
     - Profile photo (optional)
   - Then, 2–3 onboarding screens explaining platform use and benefits
   - User cannot access the platform until onboarding is complete

3. **Requesting Equipment/Procedure**
   - Select procedure/surgery from catalog (with search)
   - Default order is loaded with suggested equipment, instruments, consumables, and complements
   - User can:
     - Add/remove/modify items in the order
     - Choose between alternatives (where applicable)
   - Specify:
     - Desired delivery date
     - Coverage type (affects pricing/time)
     - Delivery address (autocomplete, save favorites)
     - Additional notes

4. **Quoting Process**
   - User submits request
   - Request is reviewed by employees (in admin webapp)
   - Employees return an estimated price based on coverage type, items, and logistics
   - User receives the quote (app and email)
   - User can accept to continue or reject/modify the request

5. **Direct Rentals/Purchases**
   - Users can rent equipment or buy consumables independently from the procedure request flow

6. **Notifications & Tracking**
   - In-app and email notifications for request status changes and reminders

7. **Support**
   - Access to FAQ, manuals, chat/email/phone support

> **Note:** Billing/Invoices are currently excluded from the user flow.

---

### 2. **WebApp for Employees/Admin (General Overview)(Do not develop yet, only as referral)**

- Receives incoming requests from doctors/clients
- Reviews and assigns estimated pricing based on coverage and logistics
- Manages inventory and delivery logistics
- Handles order tracking, confirmations, and user support

---

## 🎨 Design Guide

### Colors

**Primary (`#27737b`):**

- 100: #e0eef0
- 200: #b7d5da
- 300: #8cbcc3
- 400: #62a3ad
- 500: #27737b
- 600: #205c61
- 700: #174349
- 800: #0e2b30
- 900: #06171a

**Secondary (`#c4ffffff` translucent):**

- 100: #ffffff
- 200: #f7fcfc
- 300: #ecf8f8
- 400: #e2f3f4
- 500: #c4ffffff (80% opacity)
- 600: #b2e5e5
- 700: #9fd7d7
- 800: #87c9c9
- 900: #73bbbb

**Tertiary (`#06a1b1`):**

- 100: #e1f6fa
- 200: #b4e6ee
- 300: #81d4e0
- 400: #4ec1d1
- 500: #06a1b1
- 600: #058894
- 700: #036c74
- 800: #025057
- 900: #01323a

### Border Radius

- Small components (buttons, inputs, tags): **14px**
- Cards, modals, large elements: **18–20px**

### Typography

- **Primary:** Raleway (titles, headers, calls to action), weight 600/700
- **Secondary:** Roboto (body text, secondary labels), weight 400/500

### UI Guidelines

- Modern, clean, and minimalistic look
- Use primary and tertiary colors for key actions and highlights
- Secondary color for backgrounds, overlays, and cards (with opacity for depth)
- Inputs and cards with soft borders and light drop shadows
- Responsive layouts for mobile and desktop

---

## 🧑‍💻 Prompts for Generative AI / Reference for Developers

**Always clarify if a new feature is for:**

- App (Doctors/Clients)
- WebApp (Employees/Admin)

**App (Doctors/Clients):**

- Never expose internal management screens (inventory, staff assignment)
- All flows should be focused on making requests, modifying orders, tracking, and getting support

**Prompt Example:**

> “Develop the order request screen for doctors. User can select a procedure, edit the suggested equipment and consumables, choose delivery date, coverage type, delivery address, and add notes. When submitting, the order is sent for employee review; a quote is returned for user approval.”

---

## 📁 Example Project Structure

