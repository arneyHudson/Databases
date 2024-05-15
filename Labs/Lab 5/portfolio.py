import pandas as pd
import mysql.connector
import numpy as np

def calculate_portfolio_metrics(stock_data, weights):
    
    numeric_columns = stock_data.drop(columns=['Date']).columns
    stock_data[numeric_columns] = stock_data[numeric_columns].astype(float)

    if sum(weights) != 1.0:
        raise ValueError("Portfolio weights must sum to 1.0")

    # Extract relevant columns for calculation
    relevant_columns = ['Date', 'GOOG_Cumulative_Return', 'CELG_Cumulative_Return', 
                        'NVDA_Cumulative_Return', 'FB_Cumulative_Return', 'SPY_Cumulative_Return', 
                        'Portfolio_Cumulative_Return']


    # Calculate portfolio daily return
    portfolio_returns = (stock_data[relevant_columns].iloc[:, 1:-2] * weights).sum(axis=1)
    spy_returns = stock_data['SPY_Cumulative_Return']
    stock_data['Portfolio_Value'] = portfolio_returns
    stock_data['Portfolio_Cumulative_Return'] = portfolio_returns

    average_daily_return, std_dev_daily_return, sharpe_ratio, cumulative_return = get_sharpe_ratio(portfolio_returns, spy_returns)
    
    return average_daily_return, std_dev_daily_return, sharpe_ratio, cumulative_return






def get_sharpe_ratio(portfolio_returns, spy_returns):
    n = len(portfolio_returns)
    diff = []

    for i in range(len(portfolio_returns)):
        diff.append(portfolio_returns[i] - spy_returns[i])
    
    cumulative_return = (portfolio_returns[n-1] - portfolio_returns[0]) / portfolio_returns[0]
    portfolio_mean = np.average(diff)
    portfolio_std_dev = np.std(diff)
    sharpe_ratio = (np.sqrt(n) * portfolio_mean) / portfolio_std_dev
    return portfolio_mean, portfolio_std_dev, sharpe_ratio, cumulative_return






def update_portfolio_table(stock_data, weights):

    connection, cursor = connect_to_database()
    numeric_columns = stock_data.drop(columns=['Date']).columns
    stock_data[numeric_columns] = stock_data[numeric_columns].astype(float)
    for index, row in stock_data.iterrows():
        # Calculate the daily value for each stock using the provided formula
        for stock in weights.keys():
            daily_value = weights[stock] * row['Portfolio_Value'] * row[f"{stock}_Cumulative_Return"]
            stock_data.at[index, f"{stock}_Value"] = daily_value

            query = f"UPDATE portfolio2 SET {stock}_Value = %s WHERE Date = %s"
            cursor.execute(query, (daily_value, row['Date']))
        

    for index, row in stock_data.iterrows(): 
        query = "UPDATE portfolio2 SET Portfolio_Value = %s, Portfolio_Cumulative_Return = %s WHERE Date = %s"
        cursor.execute(query, (row['Portfolio_Value'], row['Portfolio_Value'], row['Date']))

        query = "UPDATE portfolio2 SET SPY_Value = %s WHERE Date = %s"
        cursor.execute(query, (row['SPY_Cumulative_Return'], row['Date']))

    connection.commit()
    close_connection(cursor, connection)







def retrieve_stock_data_from_database():
    connection, cursor = connect_to_database()
    # Query stock data from database
    query = "select * from portfolio2"

    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]
    data = cursor.fetchall()
    stock_data = pd.DataFrame(data, columns=columns)
    
    close_connection(cursor, connection)
    
    return stock_data



def connect_to_database():
    db_config = {
        'host': 'localhost',
        'user': 'root',
        'password': 'Msoe598903082903!',
        'database': 'data_analytics_2017'
    }
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()
    return connection, cursor



def close_connection(cursor, connection):
    cursor.close()
    connection.close()



def update_weights_dict(weights_list):
    stocks = ['GOOG', 'CELG', 'NVDA', 'FB']
    weights_dict = {stock: weight for stock, weight in zip(stocks, weights_list)}
    return weights_dict



def main():
    stock_data = retrieve_stock_data_from_database()
    weights = [0.0, 0.0, 1.0, 0.0]  

    average_daily_return, std_dev_daily_return, sharpe_ratio, cumulative_return = calculate_portfolio_metrics(stock_data, weights)

    print("Portfolio Metrics:")
    print("\tStandard Deviation:", std_dev_daily_return)
    print("\tAverage Daily Return:", average_daily_return)
    print("\tSharpe:", sharpe_ratio)
    print("\tCumulative Return:", cumulative_return)
    print("\tWeights:", weights)

    weights_dict = update_weights_dict(weights)

    update_portfolio_table(stock_data, weights_dict)

if __name__ == "__main__":
    main()