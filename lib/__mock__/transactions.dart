import 'package:wheredidispend/models/transaction.dart';

final transactions = [
  {
    "_id": "61f9c70a81f30c7d4a3b3c1a",
    "description": "Paid at the food truck",
    "amount": 376.42,
    "currency": "INR",
    "date": "2022-06-15T08:42:17.593Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c1b",
    "amount": 548.77,
    "currency": "INR",
    "date": "2023-05-02T20:17:44.102Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c1c",
    "description": "Paid at the groceries store",
    "amount": 127.95,
    "currency": "INR",
    "date": "2022-03-18T14:29:36.725Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c1d",
    "description": "Paid for hotel booking on Goa trip",
    "amount": 879.31,
    "currency": "INR",
    "date": "2023-08-29T04:05:09.221Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c1e",
    "description": "Bought coffee at the cafe",
    "amount": 254.63,
    "currency": "INR",
    "date": "2022-11-07T17:50:58.142Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c1f",
    "description": "Paid for movie tickets",
    "amount": 634.12,
    "currency": "INR",
    "date": "2023-03-25T09:18:37.889Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c20",
    "description": "Dinner at the restaurant",
    "amount": 71.88,
    "currency": "INR",
    "date": "2022-08-10T21:14:29.414Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c21",
    "description": "Shopping spree",
    "amount": 463.27,
    "currency": "INR",
    "date": "2023-09-17T12:33:04.500Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c22",
    "description": "Paid for concert tickets",
    "amount": 876.54,
    "currency": "INR",
    "date": "2022-02-14T06:45:12.789Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c23",
    "description": "Lunch with friends",
    "amount": 198.47,
    "currency": "INR",
    "date": "2023-04-30T18:22:50.935Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c24",
    "description": "Online shopping",
    "amount": 542.16,
    "currency": "INR",
    "date": "2022-07-03T11:11:33.621Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c25",
    "description": "Paid for gym membership",
    "amount": 311.78,
    "currency": "INR",
    "date": "2023-11-12T23:59:59.999Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c26",
    "description": "Bought books at the bookstore",
    "amount": 155.23,
    "currency": "INR",
    "date": "2022-05-20T15:38:27.874Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c27",
    "description": "Paid for car maintenance",
    "amount": 432.89,
    "currency": "INR",
    "date": "2023-01-08T07:30:45.201Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c28",
    "description": "Weekend getaway expenses",
    "amount": 789.56,
    "currency": "INR",
    "date": "2022-09-22T03:20:18.009Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c29",
    "description": "Paid for art supplies",
    "amount": 298.14,
    "currency": "INR",
    "date": "2023-07-16T16:12:56.318Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c2a",
    "description": "Dinner at the sushi restaurant",
    "amount": 453.72,
    "currency": "INR",
    "date": "2022-12-05T09:59:01.478Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c2b",
    "description": "Paid for online course",
    "amount": 120.89,
    "currency": "INR",
    "date": "2023-06-02T13:45:30.569Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c2c",
    "description": "Bought new headphones",
    "amount": 673.21,
    "currency": "INR",
    "date": "2022-04-17T19:33:22.156Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c2d",
    "description": "Coffee with colleagues",
    "amount": 87.35,
    "currency": "INR",
    "date": "2023-02-28T22:08:11.045Z"
  },
  {
    "_id": "61f9c70a81f30c7d4a3b3c2e",
    "description": "Paid for gardening supplies",
    "amount": 579.43,
    "currency": "INR",
    "date": "2022-10-25T10:50:36.632Z"
  },
].map((e) => Transaction.fromJson(e)).toList();
