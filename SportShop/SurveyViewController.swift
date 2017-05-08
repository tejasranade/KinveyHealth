//
//  SuverViewController.swift
//  KinveyHealth
//
//  Created by Victor Hugo on 2017-05-04.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import ResearchKit
import Kinvey
import KinveyResearchKit

class SurveyViewController: UIViewController {
    
    lazy var resultStore = DataStore<TaskResult>.collection(.network)
    
    lazy var consentDocument: ORKConsentDocument = {
        let consentDocument = ORKConsentDocument()
        consentDocument.title = "Survey Consent"
        
        var sections = [ORKConsentSection]()
        
        let overviewConsentSection = ORKConsentSection(type: .overview)
        overviewConsentSection.summary = "Overview"
        overviewConsentSection.content = "This section reforcers the user authorizes the submission of all data collected by the survey."
        
        consentDocument.sections = [overviewConsentSection]
        
        consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "Consent Signature"))
        
        return consentDocument
    }()
    
    lazy var consentTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        let visualConsentStep = ORKVisualConsentStep(identifier: "Visual Consent Step", document: self.consentDocument)
        steps += [visualConsentStep]
        
        let signature = self.consentDocument.signatures!.first
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: "Consent Review Step", signature: signature, in: self.consentDocument)
        
        reviewConsentStep.text = "Consent Review"
        reviewConsentStep.reasonForConsent = "Consent to join study"
        
        steps += [reviewConsentStep]
        
        return ORKOrderedTask(identifier: "Consent Task", steps: steps)
    }()
    
    lazy var surveyTask: ORKTask = {
        let instructionStep = ORKInstructionStep(identifier: "Survey Instruction")
        instructionStep.title = "Instructions"
        instructionStep.text = "Please fill the survey with the best of your knowledge."
        
        let summaryStep = ORKInstructionStep(identifier: "Suvery Summary")
        summaryStep.title = NSLocalizedString("Thanks", comment: "")
        summaryStep.text = NSLocalizedString("Thank you for participating in this survey.", comment: "")
        
        return ORKOrderedTask(identifier: "Survey", steps: [
            instructionStep,
            ORKQuestionStep(identifier: "Question Feeling Better", title: "Are you feeeling better today?", answer: ORKBooleanAnswerFormat()),
            ORKQuestionStep(identifier: "Question Describe", title: "Describe how are you feeling today?", answer: ORKTextAnswerFormat()),
            summaryStep
        ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitConsent(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: consentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true)
    }

    @IBAction func takeSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true)
    }
    
}

extension SurveyViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Swift.Error?) {
        resultStore.save(taskViewController.result) { (result: Kinvey.Result<TaskResult, Swift.Error>) in
            switch result {
            case .success(let taskResult):
                print("Task Result: \(taskResult)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        taskViewController.dismiss(animated: true)
    }
    
}
