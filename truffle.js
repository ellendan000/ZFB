module.exports = {
    networks: {
        development: {
            host: "127.0.0.1", // localhost
            port: 8545,
            network_id: "*",
        },

        ropsten: {
            host: "localhost",
            port: 8546,
            network_id: "3",
            from: "{YOUR_ADDRESS}",
            gas: 4600000,
        },
    },
};
