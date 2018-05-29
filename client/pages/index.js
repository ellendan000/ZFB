import {getTokenInfo, exchangeForToken} from "../web3/tokens";
import {publishProperty, getProperty, submitRent, getRents, agreeRent, getRental} from "../web3/properties";

export default class IndexPage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            propertyId: 1
        }
    }

    showToken = async () => {
        const tokenAmount = await getTokenInfo();
        console.log("ZFB amount: ", tokenAmount);
    };

    exchangeToken = async () => {
        await exchangeForToken('1');
        console.log('Completed');
    };

    publishProperty = async () => {
        const id = await publishProperty('一室一厅');
        this.setState({propertyId: id});
        console.log(id);
    };

    getProperty = async () => {
        console.log(this.state.propertyId);
        const displayInfo = await getProperty(this.state.propertyId);
        console.log(displayInfo);
    };

    getRents = async () => {
        const displayInfo = await getRents(this.state.propertyId);
        console.log(displayInfo);
    };

    submitRent = async () => {
        await submitRent(this.state.propertyId, new Date().getTime() / 1000, 1, 4);
        console.log('Completed');
    };

    agreeRent = async () => {
        await agreeRent(this.state.propertyId);
        console.log('Completed');
    };

    getRental = async () => {
        await getRental(this.state.propertyId);
        console.log('Completed');
    };

    render() {
        return (
            <div>
                <div>
                    <div>ZFB</div>
                    <button onClick={this.showToken}>
                        读取当前账户ZFB数量
                    </button>

                    <button onClick={this.exchangeToken}>
                        转1以太币换去ZFB
                    </button>
                </div>

                <div>
                    <div>房主</div>
                    <button onClick={this.publishProperty}>
                        发布房源
                    </button>

                    <button onClick={this.agreeRent}>
                        确定出租
                    </button>

                    <button onClick={this.getRental}>
                        取得租金
                    </button>
                </div>

                <div>
                    <div>租客</div>
                    <button onClick={this.submitRent}>
                        发起租赁交易
                    </button>
                </div>

                <div>
                    <div>查询房屋租赁信息</div>
                    <button onClick={this.getProperty}>
                        显示房屋信息
                    </button>

                    <button onClick={this.getRents}>
                        显示房屋的租赁信息
                    </button>
                </div>
            </div>
        )
    }
}