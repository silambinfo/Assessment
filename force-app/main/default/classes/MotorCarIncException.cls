public class MotorCarIncException Extends Exception{
	private String errorCode;
    private String errorMessage;
    public MotorCarIncException(String erroCode,String errorMessage){
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }
}