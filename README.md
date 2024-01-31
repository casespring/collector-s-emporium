# collector-s-emporium

# WorkingTitle 'Collectify'

Collectify is a social media app designed for collectors who want to share their unique collections with the world. Whether you collect stamps, vintage books, action figures, or any other treasures, Collectify provides a dedicated space for enthusiasts to connect, showcase, and engage with each other.

## Features


- User Profiles: Personalized profiles where collectors can showcase information about themselves and their collections.

- Collection Sharing: Ability for users to create, upload, and share collections with titles, descriptions, and images.

- User Authentication: Secure sign-up and login system to create and manage user accounts.

- News Feed: A dynamic timeline where users can discover and interact with collections from others.

- Likes and Comments: Social interactions to express appreciation and engage in discussions about collections.

- Forums: Community tab allowing users to create forums, post discussions, and connect with fellow collectors.

- Marketplace: A marketplace where users can share items from their collections for sale or trade.

- Bookmarks: Users can bookmark collections, posts, and marketplace items for quick access.

- Notifications: Receive notifications for likes, comments, follows, and other interactions.

## Technology Stack

- Frontend: [Flutter](https://docs.flutter.dev/) with [Dart]

- Backend: [Django](https://www.djangoproject.com/) with [Python] / [Flask](https://flask.palletsprojects.com/en/3.0.x/) / [Firebase Authentication](https://firebase.google.com/products/auth) 

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/casespring/collector-s-emporium.git
   ```

2. Install dependencies:

   ```bash
   cd client
   cd collector-s-emporium
   flutter pub get
   flutter run
   ```

3. Set up the backend:

   - Configure your database settings in `backend/config/db.js`.
   - Set up authentication credentials if applicable.

4. Start the server:

   ```bash
   cd flask-backend
   pipenv install
   pipenv shell
   cd server
   python app.py
   ```

5. Start the frontend:

   ```bash
   cd client
   cd collecotrs_social_media_app
   flutter run 
   ```

6. Open the app in your preferred emulator or device.