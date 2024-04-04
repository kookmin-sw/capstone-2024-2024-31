package km.cd.backend.challenge.controller;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.ChallengeDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.service.ChallengeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ChallengeController {

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private final ChallengeService challengeService;
    private final Logger log = LoggerFactory.getLogger(getClass());

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @GetMapping("/challenge/create_form")
    public String newChallengeForm() {
        return "/challenge/create_form2";
    }

    @PostMapping("/challenge/create_form")
    public String createChallenge(@ModelAttribute ChallengeDto challengeDTO, RedirectAttributes redirectAttributes) {
        log.info(challengeDTO.toString());
        ChallengeResponseDto saved = challengeService.saveChallenge(challengeDTO);
        log.info(saved.toString());
        redirectAttributes.addAttribute("challenge_id", saved.getChallengeId());
        return "redirect:/challenge/success";
    }

    @GetMapping("/challenge/success")
    public String showSuccessPage(@RequestParam Integer challenge_id, Model model) {
        model.addAttribute("challenge_id", challenge_id);
        return "/challenge/success2";
    }


}
