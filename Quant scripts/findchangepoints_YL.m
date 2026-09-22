% This code is modified from 'findchangepoints_jsb.m' such that it is
% integrated into the 'mCitrine_BaLM.m' code. The algorithm for detecting
% intensity steps remains the same.

function f = findchangepoints_YL(binnedC, WinSize, LMthresh)

if nargin < 3
    LMthresh = 300;
    if nargin < 2
        WinSize = 300;
    end
end 
    
% % % % % Find change points
        % % % % % Yan Jiang 09/09/07
        % % % % % Algorithm based on Watkins and Yang, J. Phys. Chem. B, Vol. 109, No. 1,
        % % % % % 617-628(2005) and Boudjellaba et al, Commun. Statist. - Theory Meth., 30(3),
        % % % % % 407-434(2001)
        % % % % % Edited on 10/22/07 by Yan to include comments and make
        % the change points storing
        % % % % % vector and the name of several variables more reasonable.
        % % % % % Edited on 2/2/08 by Yan to include the Poisson fitting for the stepsize
        % % % % % distribution and the visualization of the found events.
        % % % % % Edited 1/09 by Randall Goldsmith for incorporation into lifetime analysis and to include more comments 
        % % % % % Edited 10/12 by Julie Biteen to run like a program

        % % % clear all

%         fprintf('\n finding changepoints   ') %JSB?

%         global L; %JSB?
        
        % Read in the raw data and choose part of it to be analyzed.
        %% Specify the data you want to analyze.  It should be in a one
        %% dimensional vector called "binnedC".  The main output containing
        %% the found changepoints and levels will be in the vector
        %% "filtered".  A supporting function "LRtest2" is also required.  

%       binnedC=load(filename);
        nData=length(binnedC);
        data=binnedC((nData*0+1):(nData*1));
        % Initialize vector ChangePnt, in which each 1 indicate a change point.
        ChangePnt=zeros(1,nData);
        ChangePnt(1)=1;
        ChangePnt(nData)=1;
        % Find the change points
        %% WinSize is the smallest segment that you want to look for change point
        %% in it.
%         WinSize=300; %JSB
        crntChange=1;
        nxtChange=nData;
        nCPnt=2;
        while(crntChange<nData) % when not every change points are found
            if((nxtChange-crntChange)>WinSize) % if the current data segment is long enough, try to find a change point inside this segment
                datain=data((crntChange+1):nxtChange); 
                [Cpt, LM]=LRtest2(datain);
                % If the change point found just now is real, update the ChangePnt
                % vector and cut the data segment at this change point.
                % Otherwise go on the the next segment of data.
                %% LM is a threshold. For now you have to try.
                %if(LM>40) 
                if(LM>LMthresh) %JSB - this number might need changing
%                     datalength(nCPnt)=length(datain); %JSB?
                    ChangePnt(crntChange+Cpt)=1;
                    nCPnt=nCPnt+1;
                    nxtChange=crntChange+Cpt;
                else
                    crntChange=nxtChange;
                    if(crntChange<nData)
                        nxtChange=nxtChange+1;
                        while(ChangePnt(nxtChange)==0)
                            nxtChange=nxtChange+1;
                        end
                    end
                end
            else % if the segment is too short, go on to the next segment of data.
                crntChange=nxtChange;
                if(crntChange<nData)
                    nxtChange=nxtChange+1;
                    while(ChangePnt(nxtChange)==0)
                        nxtChange=nxtChange+1;
                    end
                end
            end
        end
        % Organize the position of the change points to a new vector tCPnt.
        tCPnt=zeros(1,nCPnt);
        i=1;
        t=1;
        while(t<nData)
            while(ChangePnt(t)==0)
                t=t+1;
            end
            tCPnt(i)=t;
            t=t+1;
            i=i+1;
        end

        % Below is one set of Data analysis. Use the value in the 'if' sentence to choose.

        % Visualize the result by drawing the raw data and the stepped data in a
        % same figure.
        filtered=zeros(1,nData);
        for j=1:(nCPnt-1)
            Ilevel(j)=sum(data((tCPnt(j)+1):tCPnt(j+1)))/(tCPnt(j+1)-tCPnt(j)); %#ok<AGROW>
            for i=(tCPnt(j)+1):(tCPnt(j+1))
                filtered(i)=Ilevel(j);
            end
        end
        
        filtered(1) = filtered(2); %JSB - for some reason, the first value is set to zero
        
%         figure()
%         plot(binnedC)
%         hold on
%         plot(filtered, 'r','LineWidth',2)
%         set(gca,'FontSize', 14,'LineWidth',2)
%         ylabel('Intensity', 'FontSize',16)
%         xlabel('Frame #', 'FontSize',16)
% %        title([' WinSize = ' num2str(WinSize) ' LMthresh = '
% %        num2str(LMthresh)],'FontSize',10)
        
        f = filtered; %JSB - Return the stepping data

end % End of function 'findchangepoints_YL.m'