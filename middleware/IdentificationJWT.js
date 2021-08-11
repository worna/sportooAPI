require('dotenv').config();
const process = require('process');
const jwt = require('jsonwebtoken');

/**
 * @swagger
 * components:
 *  securitySchemes:
 *      bearerAuth:
 *          type: http
 *          scheme: bearer
 *          bearerFormat: JWT
 *  responses:
 *      ErrorJWT:
 *          description: The JWT is invalid
 *      MissingJWT:
 *          description: The JWT is not present
 */
module.exports.identification = async (req, res, next) => {
    const headerAuth = req.get('authorization');
    if(headerAuth !== undefined && headerAuth.includes("Bearer")){
        const jwtToken =  headerAuth.split(' ')[1];
        try{
            const decodedJwtToken = jwt.verify(jwtToken, process.env.SECRET_TOKEN);
            req.session = decodedJwtToken.value;
            req.session.authLevel = decodedJwtToken.status;
            next();
        }
        catch (error) {
            console.log(error);
            res.sendStatus(400);
        }
    } else {
        console.log("You must be connected with Bearer");
        res.sendStatus(401);
    }
};