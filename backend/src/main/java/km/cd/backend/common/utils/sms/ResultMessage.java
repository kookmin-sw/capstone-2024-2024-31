package km.cd.backend.common.utils.sms;

public class ResultMessage {
    
    public static String getSuccessMessage(String challengeName, String targetName, String userName, String determination){
        StringBuilder sb = new StringBuilder();
        sb.append("안녕하세요! 갓생지키미\uD83D\uDD25 루틴업입니다.\n\n");
        sb.append(targetName + "님의 친구 " + userName + "께서 <" + challengeName +"> 챌린지를 성공했어요\uD83D\uDE06\n\n");
        sb.append(userName +"님이 " + targetName + "님꼐 Memo를 남겼어요!\n");
        sb.append("\"" + determination + "\"");
        return sb.toString();
    }
    public static String getFailureMessage(String challengeName, String targetName, String userName, String determination){
        StringBuilder sb = new StringBuilder();
        sb.append("안녕하세요! 갓생지키미\uD83D\uDD25 루틴업입니다.\n\n");
        sb.append(targetName + "님의 친구 " + userName + "께서 <" + challengeName +"> 챌린지를 실패했어요\uD83D\uDD25\n\n");
        sb.append(userName +"님이 " + targetName + "님꼐 Memo를 남겼어요!\n");
        sb.append("\"" + determination + "\"");
        return sb.toString();
    }
}
