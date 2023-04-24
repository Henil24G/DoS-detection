clc
clear all
load("norm_joint_entropy")

FPR = []; 
TPR = []; 

% Lable (D)DoS traffic between (300th sec and 1200th sec)
traffic_label = zeros(1, 1799);
traffic_label(300:1200) = 1;

for threshold = [0.2 0.3 0.4 0.5 0.6] % loop over different threshold values
% Classify time windows as normal or attack traffic
is_attack = norm_mean_flag < threshold;

% Calculate detection rate
num_attacks = sum(traffic_label == 1); % traffic_label
num_detected_attacks = sum(is_attack & (traffic_label == 1)); % true positive
detection_rate = num_detected_attacks / num_attacks;
TPR = [TPR detection_rate*100];
false_postive = sum(is_attack & (traffic_label == 0)); % false positve 
false_postive_rate = false_postive/(sum(traffic_label == 0));
FPR = [FPR false_postive_rate*100];
end

tpr1 = [0 TPR(1) 100];
fpr1 = [0 FPR(1) 100];

tpr2 = [0 TPR(2) 100];
fpr2 = [0 FPR(2) 100];

tpr3 = [0 TPR(3) 100];
fpr3 = [0 FPR(3) 100];

tpr4 = [0 TPR(4) 100];
fpr4 = [0 FPR(4) 100];

tpr5 = [0 TPR(5) 100];
fpr5 = [0 FPR(5) 100];

figure
plot(fpr1, tpr1, '--o','LineWidth', 1);
hold on;
plot(fpr2, tpr2, '--*','LineWidth', 1);
hold on;
plot(fpr3, tpr3, '--x','LineWidth', 1);
hold on;
plot(fpr4, tpr4, '--diamond','LineWidth', 1);
hold on;
plot(fpr5, tpr5, '--square','LineWidth', 1);
hold on;

% Add labels and title
legend({'th=0.2','th=0.3','th=0.4','th=0.5','th=0.6'},'Location','southeast')
xlabel('False Positive Rate (%)');
ylabel('Detection Rate(%)');
title('ROC curve');
hold off;