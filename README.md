# MyGMR Project

## Overview
The MyGMR project consists of a backend running on Google Cloud App Engine and a mobile app built with Flutter for Android. This project allows users to manage GMR devices and their associated tasks.

## Project Structure
- **flutter_app**: Contains the Flutter mobile application.
- **server**: Contains the backend server code for Google Cloud App Engine.
- **test**: Contains testing scripts and data for the server.

## Prerequisites
- **Flutter**: To run the mobile app, install Flutter from [here](https://flutter.dev/docs/get-started/install).
- **Python**: Required for the backend server. Install Python 3.9 or higher.
- **Google Cloud SDK**: To deploy the backend server on Google Cloud. Install from [here](https://cloud.google.com/sdk/docs/install).

## Installation and Setup

In this case, there are two ways to utilize our app, either by installing our APK or through Android Studio using a virtual machine of an Android Phone:

### APK
The easiest way to run our app is to install our APK on your phone device. In this case, this APK is only compatible with Android phones. You can find our APK in the following location:
```path
    ./APKs/app-realese.apk
```

### Backend Server

This will be the steps to run your own server:

#### Prerequisites

 - Having a google cloud project with the necessary cloud storage, cloudSQL and app engine setted up. Also you will need your [service account json](https://cloud.google.com/iam/docs/keys-list-get)

 - Having a firebase linked to that gcloud project with the following settings:
   - Authentication system with (at least) a google provider
   - Add the flutter app package to the project along with the [SHA1 key](https://stackoverflow.com/questions/45494925/get-sha-1-for-android-firebase)

You need the following secret files in order to run the app completly (if you don't have them already):
 
   - **server/your-project-random-string.json** this is your service account json
   - **server/.env** add the following environment environment variables
      - GOOGLE_APPLICATION_CREDENTIALS: your google service account json
      - INSTANCE_CONNECTION_NAME: project-name:timezone:cloudsql-instance-id
      - DB_USER: username of your database user
      - DB_PASS: password of your database user
      - DB_NAME: name of your databas
      - FLASK_SECRET_KEY: random string to handle flask sessions
      - CLOUD_IMAGE_FOLDER: the cloud bucket name for your files
      - CLOUD_BUCKET_BASE_URL: generally https://storage.googleapis.com 


#### Running the Server Locally
1. Create a virtual environment with the requisite:
    ```bash
    python -m venv venv
   source venv/bin/activate   # On Windows, use `venv\Scripts\activate`
    ```

2. Install the dependencies:
    ```bash
    pip install -r requirements.txt
    ```
   
   Alternatively, you can use our enviroment.yml
   ```bash
   conda env create --name my_gmr -f environment.yml
   conda activate my_gmr
   ```

3. Run the server:
    ```bash
    python run.py
    ```

#### Deploying the Server to Google Cloud App Engine
1. Authenticate with Google Cloud:
    ```bash
    gcloud auth login
    ```

2. Set your Google Cloud project:
    ```bash
    gcloud config set project YOUR_PROJECT_ID
    ```

3. Deploy the application:
    ```bash
    gcloud app deploy
    ```

### Running the test robot

#### Prerequisites

The same as the server, you need a running server on the cloud along with the following secret files:

   - **server/test/your-project-random-string.json** this is your service account json

   - **server/test/.env** add the following environment environment variables
      - SERVER_URL: your app engine server URL
      - BUCKET_NAME: your buckent name
      - GOOGLE_APPLICATION_CREDENTIALS: to your google service account json

#### Setting up the robot

To run a test client robot you have to use the same environment as said before. In this case, before running any client, you have to add and ID of 8 digits, which simulates the plate/ID of the GMR device.

To add this ID of 8 digits you have to access to a json file, the path is the following one:
```bash
    python server/test/robot_data.json
```
In this file you have to write yourself the ID of the GMR device, modifying the "matricula" entry:
```bash
   {
      "matricula": 87654321,
      "model_id": 1
   }
```

#### Running

Once you have done it, you can run your test server without problem running the following command in your console:
```bash
    python ./server/test/test_robot_client.py
```

### Mobile App

#### Debug Mode
1. Navigate to the `flutter_app` directory:
    ```bash
    cd flutter_app
    ```

2. Ensure all Flutter dependencies are installed:
    ```bash
    flutter pub get
    ```

3. Connect an Android device or start an Android emulator.

4. Run the app in debug mode:
    ```bash
    flutter run
    ```

#### Release Mode
1. Build the APK:
    ```bash
    flutter build apk --release
    ```

2. The release APK can be found in `build/app/outputs/flutter-apk/app-release.apk`.

#### Running Tests
1. Modify the `matricula` field in `robot_data.json` in the `server/test` directory as needed.

2. Run the test client to verify functionalities:
    ```bash
    python test_robot_client.py
    ```

## Contributing
1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License
This project is licensed under the MIT License.

For any issues or questions, please open an issue on the project's GitHub page.