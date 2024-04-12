//package km.cd.backend.kafka;
//
//import java.util.concurrent.CompletableFuture;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.kafka.core.KafkaTemplate;
//import org.springframework.kafka.support.KafkaHeaders;
//import org.springframework.kafka.support.SendResult;
//import org.springframework.messaging.Message;
//import org.springframework.messaging.support.MessageBuilder;
//import org.springframework.stereotype.Component;
//
//@Slf4j
//@Component
//@RequiredArgsConstructor
//public class KafkaProducerCluster {
//
//    private final KafkaTemplate<String, KafkaEntity> kafkaTemplate;
//
//    @Value("${spring.kafka.template.default-topic}")
//    private String topicName;
//
//    public void sendMessage(KafkaEntity kafkaEntity) {
//
//        Message<KafkaEntity> message = MessageBuilder
//            .withPayload(kafkaEntity)
//            .setHeader(KafkaHeaders.TOPIC, topicName)
//            .build();
//
//        CompletableFuture<SendResult<String, KafkaEntity>> future =
//            kafkaTemplate.send(message);
//
//        future.whenComplete((result, ex) -> {
//            if (ex == null) {
//                log.info("producer: success >>> message: {}, offset: {}",
//                    result.getProducerRecord().value().toString(), result.getRecordMetadata().offset());
//            } else {
//                log.info("producer: failure >>> message: {}", ex.getMessage());
//            }
//        });
//
//    }
//
//}