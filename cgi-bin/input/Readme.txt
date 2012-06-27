This folder contains scripts that are used to fetch and store input data from yahoo.

extractYahooStocks.pl
	goes to the WWW and downloads stock history data for each stock index (amex, nasdaq, nyse) defined in the csv files: amex.csv, nasdaq.csv, nyse.csv contained in the Input\CSV directory. Each stock is saved as a file in the directory Input\ExtractedData

insertStocksToDB.pl
	goes through each file in the directory Input\ExtractedData and stores them in the database

insertStocksToDBToday.pl
	goes to the WWW and downloads stock data for today for each stock index (amex, nasdaq, nyse) defined in the csv files: amex.csv, nasdaq.csv, nyse.csv contained in the Input\CSV directory. The data is inserted into the database