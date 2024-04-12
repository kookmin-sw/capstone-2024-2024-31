//package km.cd.backend.kafka;
//
//import lombok.RequiredArgsConstructor;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//@RequiredArgsConstructor
//public class KafkaControllerCluster {
//
//    private final KafkaProducerCluster producer;
//
//    @PostMapping("/kafka/produce/cluster")
//    public String sendMessage(@RequestBody KafkaEntity message) {
//        producer.sendMessage(message);
//
//        return "ok";
//    }
//}
