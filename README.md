![Station](https://github.com/Milan-Wcislo/Payment-For-Fuel-By-License-Plate/assets/91840395/bd871045-2d06-45b0-b6f0-a4ef1001eddd)
# Payment For Fuel Using The License Plate System

## 🥈 Awarded Second Place in the Małopolska Region's "Małopolski Konkurs Własnych Prac Technicznych" Competition in the Computer Science Category

## How It Works?

https://github.com/Milan-Wcislo/Payment-For-Fuel-By-License-Plate/assets/91840395/a08cd336-3dcf-4f10-99a0-f3f52cd7e65f

----------------

### Fuel Payment

1. Customer registration and vehicle registration on the web application.
2. ANPR system reads the vehicle's license plate using a camera.
3. Data is sent to the web application, which initiates the payment process.
4. The user opens the mobile app, and a payment window appears within seconds.

### Loyalty Program


* A loyalty program is initiated when a user profile is created.
* Points earned during fuel purchases can be redeemed for various products.

## Applications Overview
This project aims to provide a comfortable and efficient fuel payment experience for customers. The system consists of three interconnected applications:

----------------

#### Web Application "Station"
A Django-based web application for customer registration and payment processing.

----------------

#### Mobile Application "Station App"
A Flutter-based mobile app for fuel payment and loyalty program management.

----------------

#### Artificial Intelligence for Vehicle License Plate Recognition
A TensorFlow and OpenCV-based system for automatic number plate recognition (ANPR).

----------------

## Technical Operation

### Technologies Used

* **Django**: Web Application "Station"
* **Flutter**: Mobile Application "Station App"
* **TensorFlow & OpenCV**: Automatic Number Plate Recognition (ANPR)
* **PostgreSQL**: Database

![Technologies](https://github.com/Milan-Wcislo/Payment-For-Fuel-By-License-Plate/assets/91840395/e37c466d-1cda-4d79-b8ff-ff06c6a8df58)

## Practical Usage Examples

* The project can be integrated with a gas station to provide convenient fuel payment and loyalty program management.
* Customers can use the system to make efficient fuel payments without leaving their vehicle.
* The loyalty program encourages repeat customer visits and rewards point collection.

## Detailed Explanation

### Web Application

The project begins by registering customers and their vehicles through a dedicated web application built with Django. This platform uses PostgreSQL for its database models. Communication between different components is handled via REST APIs developed using Django Rest Framework (DRF). Key security measures are implemented, including:
- Password encryption using the PBKDF2 algorithm with random salting.
- Secure data transfer using the CSRF token mechanism.

The application features an intuitive admin panel that allows for the easy addition of new gas stations, products for points, and the configuration and management of all significant tables. Users can purchase products using points from the "Loyalty Program." The user registration process leverages Django Forms, ensuring data security and integrity. Overall, the project combines functionality, security, and ease of administration to create an efficient platform for serving customer needs.

### License Plate Recognition System

The project includes a license plate recognition system powered by artificial intelligence (AI). This system uses a TensorFlow-based model trained with TensorFlow Object Detection to recognize and read license plates from video footage. By applying the Region of Interest (ROI) technique, the model extracts relevant data. The "EasyOCR" library is employed to read the plate content, while OpenCV facilitates camera integration. The extracted data is sent via REST API to the Django server, where it is stored in the PostgreSQL database. This process also creates a new payment record in the Django system.

### Mobile Application

The mobile application, developed using Flutter, enables fuel payments and integrates seamlessly with the Django web application through "Django Simple JWT." This integration ensures secure user login and authorization using AccessToken and RefreshToken mechanisms. When a payment process is initiated, the application automatically opens the payment window upon receiving data, leveraging REST API and listening mechanisms. Users can quickly and conveniently settle fuel costs using GooglePay. Additionally, the mobile app allows users to purchase products with loyalty points and displays a barcode with available coupons, which can be easily scanned at the checkout for future purchases.


## Bugs
When in payment process, after 5 minutes payment will expire and error will occur.

## Contact

For any questions, please contact:

* **Author**: Milan Wcislo
* **Email**: milanwcislo@gmail.com
* **GitHub**: [Milan-Wcislo](https://github.com/Milan-Wcislo)

Thank you for checking out this project! Your support and feedback are greatly appreciated.
