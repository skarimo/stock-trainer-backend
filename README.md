# README

Stock Trainer Backend

---------- DESCRIPTION ----------
Stock trainer is a realistic stock market training game that makes use of real time stock prices to allow users buy and sell with fake currency. Algorithm are employed to generate life like buy and sell feature based on stocks real time price, and volume.

------------- STEPS ------------

1) Begin with running command - $ bundle install - to install all dependencies

2) Migrate the tables - $ rails db:migrate - , followed by - $ rails db:seed - to seed the database with stocks and its symbols

3) - $ rails s - to start up the rails api server. Use port http://localhost:3000/

4) launch the Stock-trainer-frontend. The frontend makes use of backend hosted on port 3000. Change the frontend links as necessary.
