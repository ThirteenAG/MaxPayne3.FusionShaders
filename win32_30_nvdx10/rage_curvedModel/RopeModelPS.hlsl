float4 gLightColor[4] : register(c39);
float4 gLightPosDir[4] : register(c16);
float4 gLightType : register(c28);
row_major float4x4 gViewInverse : register(c12);

struct PS_IN
{
	float3 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	float3 r5;
	float3 r6;
	r0.xyz = gLightPosDir[0].xyz + -i.texcoord.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r1.xyz = r0.www * r0.xyz;
	r0.w = 1 / r0.w;
	r0.xyz = (-r0.www >= 0) ? r0.xyz : r1.xyz;
	r1.x = 1;
	r2.xyz = min(gLightType.xyz, r1.xxx);
	r1.xyz = lerp(-gLightPosDir[0].xyz, r0.xyz, r2.xxx);
	r0.xyz = gViewInverse[3].xyz + -i.texcoord.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r3 = r0.xyz * r0.www + r1.xyz;
	r4 = normalize(r1.xyz);
	r1.xyz = normalize(r3.xyz);
	r3 = normalize(i.texcoord2.xyz);
	r1.x = saturate(dot(r1.xyz, r3.xyz));
	r5 = gLightPosDir[1].xyz + -i.texcoord.xyz;
	r1.w = dot(r5.xyz, r5.xyz);
	r1.w = rsqrt(r1.w);
	r6 = r1.www * r5.xyz;
	r1.w = 1 / r1.w;
	r5 = (-r1.www >= 0) ? r5.xyz : r6.xyz;
	r6 = lerp(-gLightPosDir[1].xyz, r5.xyz, r2.yyy);
	r2.xyw = r0.xyz * r0.www + r6.xyz;
	r5 = normalize(r6.xyz);
	r5.y = saturate(dot(r5.xyz, r3.xyz));
	r6 = normalize(r2.xyw);
	r1.y = saturate(dot(r6.xyz, r3.xyz));
	r2.xyw = gLightPosDir[2].xyz + -i.texcoord.xyz;
	r1.w = dot(r2.xyw, r2.xyw);
	r1.w = rsqrt(r1.w);
	r6 = r1.www * r2.xyw;
	r1.w = 1 / r1.w;
	r2.xyw = (-r1.www >= 0) ? r2.xyw : r6.xyz;
	r6 = lerp(-gLightPosDir[2].xyz, r2.xyw, r2.zzz);
	r0.xyz = r0.xyz * r0.www + r6.xyz;
	r2.xyz = normalize(r6.xyz);
	r5.z = saturate(dot(r2.xyz, r3.xyz));
	r2.xyz = normalize(r0.xyz);
	r1.z = saturate(dot(r2.xyz, r3.xyz));
	r5.x = saturate(dot(r4.xyz, r3.xyz));
	r0.xyz = r1.xyz + 1E-05;
	r1.x = log2(r0.x);
	r1.y = log2(r0.y);
	r1.z = log2(r0.z);
	r0.xyz = r1.xyz * 32.00001;
	r1.x = saturate(exp2(r0.x));
	r1.y = saturate(exp2(r0.y));
	r1.z = saturate(exp2(r0.z));
	r0.xyz = r5.xyz * 0.5 + r1.xyz;
	r1.xyz = r0.yyy * gLightColor[1].xyz;
	r0.xyw = r0.xxx * gLightColor[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gLightColor[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + 0.3;
	o.xyz = r0.xyz * i.texcoord3.xyz;
	o.w = i.texcoord3.w;

	return o;
}
