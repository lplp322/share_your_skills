import jwt, { Secret, JwtPayload } from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';
const messages = require("../config/messages");

export const SECRET_KEY: Secret = 'GroupomaniaFour';

export interface CustomRequest extends Request {
    token: string | JwtPayload;
}
   
export const auth = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const token = req.header('Authorization');

        if (!token) {
            throw new Error();
        }

        const decoded = jwt.verify(token, SECRET_KEY);
        (req as CustomRequest).token = decoded;

        next();
    } catch (err) {
        res.status(messages.UNAUTHORIZED).send('Please authenticate');
    }
};