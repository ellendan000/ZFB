import {getTokenInfo, exchangeForToken} from "../web3/tokens";
import {publishProperty, getProperty, submitRent, getRents} from "../web3/properties";

export default class IndexPage extends React.Component {

    showToken = async () => {
        const tokenAmount = await getTokenInfo();
        console.log(tokenAmount);
    };

    exchangeToken = async () => {
        await exchangeForToken('1');
        console.log('Completed');
    };

    publishProperty = async () => {
        const propertyId = await publishProperty('一室一厅');
        console.log(propertyId);
    };

    getProperty = async () => {
        const displayInfo = await getProperty(1);
        console.log(displayInfo);
    };

    getRents = async () => {
        const displayInfo = await getRents(1);
        console.log(displayInfo);
    };

    submitRent = async () => {
        await submitRent(1, new Date().getTime(), 2, 2);
    };

    render() {
        return (
            <div>
                <div>
                    <button onClick={this.showToken}>
                        Get the number of Token
                    </button>

                    <button onClick={this.exchangeToken}>
                        exchange token by 1 ether
                    </button>

                    <button onClick={this.publishProperty}>
                        publish property
                    </button>
                </div>

                <div>
                    <button onClick={this.getProperty}>
                        get property id 1
                    </button>

                    <button onClick={this.getRents}>
                        get rents by id 1
                    </button>
                </div>

                <div>
                    <button onClick={this.submitRent}>
                        submit rent for property id 1
                    </button>
                </div>
            </div>
        )
    }
}