import {getTokenInfo, exchangeForToken} from "../web3/tokens";

export default class IndexPage extends React.Component {

    showToken = async () => {
        const tokenAmount = await getTokenInfo();
        console.log(tokenAmount);
    };

    exchangeToken = async () => {
        await exchangeForToken('1');
        console.log('Completed');
    };

    render() {
        return (
            <div>
                <button onClick={this.showToken}>
                    Get the number of Token
                </button>

                <button onClick={this.exchangeToken}>
                    exchange token by 1 ether
                </button>

            </div>
        )
    }
}