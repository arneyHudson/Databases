import itertools
import pandas as pd
from portfolio import calculate_portfolio_metrics
from portfolio import retrieve_stock_data_from_database
from portfolio import update_portfolio_table
from portfolio import connect_to_database
from portfolio import close_connection

def find_best_portfolio_weighting(stock_symbols, stock_data):
    # Initialize variables to store the best metrics and weighting
    best_average_daily_return = None
    best_std_dev_daily_return = None
    best_sharpe_ratio = None
    best_cumulative_return = None
    best_weighting = None

    # Generate all combinations that sum up to 1.0
    for weighting in itertools.product(*[range(11) for _ in range(len(stock_symbols))]):
        weighting = [w / 10 for w in weighting]  # Convert to actual weights (0.0 to 1.0)
        
        if sum(weighting) != 1.0:
            continue

        # Calculate portfolio metrics for the current weighting
        average_daily_return, std_dev_daily_return, sharpe_ratio, cumulative_return = calculate_portfolio_metrics(stock_data, weighting)

        # Update best metrics if current portfolio is better
        if best_sharpe_ratio is None or sharpe_ratio > best_sharpe_ratio:
            best_average_daily_return = average_daily_return
            best_std_dev_daily_return = std_dev_daily_return
            best_sharpe_ratio = sharpe_ratio
            best_cumulative_return = cumulative_return
            best_weighting = weighting
    
    return best_weighting, best_average_daily_return, best_std_dev_daily_return, best_sharpe_ratio, best_cumulative_return


def main():
    stock_data = retrieve_stock_data_from_database()
    stock_symbols = ['GOOG', 'CELG', 'NVDA', 'FB']
    best_weighting, best_average_daily_return, best_std_dev_daily_return, best_sharpe_ratio, best_cumulative_return = find_best_portfolio_weighting(stock_symbols, stock_data)
    print("Best Portfolio Metrics:")
    print("  Standard Deviation:", best_std_dev_daily_return)
    print("  Average Daily Return:", best_average_daily_return)
    print("  Sharpe Ratio:", best_sharpe_ratio)
    print("  Cumulative Return:", best_cumulative_return)
    print("Best Portfolio Weighting:", best_weighting)

    weights = {stock_symbols[i]: best_weighting[i] for i in range(len(stock_symbols))}
    update_portfolio_table(retrieve_stock_data_from_database(), weights)

    connection, cursor = connect_to_database()

    for index, row in stock_data.iterrows():
        query = "UPDATE portfolio2 SET Portfolio_Value = %s WHERE Date = %s"
        cursor.execute(query, (row['Portfolio_Value'], row['Date']))

        query = "UPDATE portfolio2 SET Portfolio_Cumulative_Return = %s WHERE Date = %s"
        cursor.execute(query, (row['Portfolio_Value'], row['Date']))

    connection.commit()
    close_connection(cursor, connection)

if __name__ == "__main__":
    main()